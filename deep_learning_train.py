import torch

device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
print(device)
exit()

import matplotlib.pyplot as plt
import math
import copy
from visualize import visualize

import optuna

def main() :
    study = optuna.create_study(direction='minimize')
    study.optimize(objective, n_trials=9999)

def objective(trial) :
    parameters = {}
    parameters["optimizerName"] = trial.suggest_categorical("Optimizer", ["adam", "sgd", "adadelta"])
    imageSize = trial.suggest_int("ImageSize", 256, 256, step=128)
    parameters["imageWidth"] = imageSize
    parameters["imageHeight"] = imageSize
    parameters["learningRate"] = trial.suggest_float("LearningRate", 1e-4, 1e-1, log=True)
    parameters["epoque"] = 10
    parameters["batchSize"] = trial.suggest_int("BatchSIze", 8, 8, step=4)
    parameters["colorDA"] = trial.suggest_float("ColorDA", 0, 0.5)
    print(device)

    # try :
    train(parameters)
    #except :
    #    return +1

# +----------------------------------+
# |               loss               |
# +----------------------------------+
def denoisingLoss(prediction, target):
    loss = torch.mean((prediction-target)**2)
    return loss
#loss = denoisingLoss
loss = torch.nn.BCELoss()

# +----------------------------------+
# |            Callbacks             |
# +----------------------------------+
class Callback_computeValidationMetrics():
    def __init__(self, validationDataloader, criterion, device):
        self.validationDataloader = validationDataloader
        self.device = device
        self.criterion = criterion

    def __call__(self, model):
        model.eval() # Deactivate Batchnorm & Dropout layers
        with torch.no_grad():

            averagedValidationLoss = 0

            for batchNumber, (xBatch, yBatch) in enumerate(self.validationDataloader):

                xBatch = xBatch.type(torch.FloatTensor).to(device)
                yBatch = yBatch.type(torch.FloatTensor).to(device)
                outputs = model(xBatch)

                # Loss
                loss = self.criterion(outputs, yBatch)
                averagedValidationLoss += loss.item()

            averagedValidationLoss /= (batchNumber+1)

        return averagedValidationLoss

def callback_visualize_results(_model, _dataset, _folderPath):
    visualize(_model, _dataset, device, folderPath = _folderPath)


def train(parameters) :

    # +----------------------------------+
    # |              Data                |
    # +----------------------------------+
    from loadData import loadData
    training_dataset, validation_dataset, test_dataset, training_generator, validation_generator, test_generator = loadData(parameters, colorDA=parameters["colorDA"])

    callback_computeValidationLoss = Callback_computeValidationMetrics(validation_generator, denoisingLoss, device)

    # +----------------------------------+
    # |              Model               |
    # +----------------------------------+
    from UNetSigmoid import UNetSigmoid
    model = UNetSigmoid()
    model.to(device)

    # +----------------------------------+
    # |            Optimizer             |
    # +----------------------------------+
    if (parameters["optimizerName"] == "adam"): optimizer = torch.optim.Adam(model.parameters(), lr=parameters["learningRate"]) #, amsgrad=True)
    if (parameters["optimizerName"] == "sgd"): optimizer = torch.optim.SGD(model.parameters(), lr=parameters["learningRate"], momentum=0.9)
    if (parameters["optimizerName"] == "adadelta"): optimizer = torch.optim.Adadelta(model.parameters(), lr=parameters["learningRate"])

    # +----------------------------------+
    # |            Save Folder           |
    # +----------------------------------+
    import datetime
    now = datetime.datetime.now()
    date = f"{now.year}y{str(now.month).zfill(2)}m{str(now.day).zfill(2)}d_{str(now.hour).zfill(2)}h{str(now.minute).zfill(2)}m{str(now.second).zfill(2)}s{str(int(now.microsecond/1e3)).zfill(3)}ms{str(int(now.microsecond%1e3)).zfill(3)}ys"
    print(date)
    saveFolderPath = f"_data/{date}"
    from pathlib import Path
    Path(saveFolderPath).mkdir(parents=True, exist_ok=True)

    # Save parameters for posterity
    import json
    with open(f"{saveFolderPath}/parameters.json", "w") as parameterFile :
        json.dump(parameters, parameterFile, indent=4)

    # Save datasets (train/valid/test split) for posterity
    import pickle
    with open(f"{saveFolderPath}/training_dataset.pkl", 'wb') as handle:
        pickle.dump(copy.deepcopy(training_dataset), handle, protocol=pickle.HIGHEST_PROTOCOL)
    with open(f"{saveFolderPath}/validation_dataset.pkl", 'wb') as handle:
        pickle.dump(validation_dataset, handle, protocol=pickle.HIGHEST_PROTOCOL)
    with open(f"{saveFolderPath}/test_dataset.pkl", 'wb') as handle:
        pickle.dump(test_dataset, handle, protocol=pickle.HIGHEST_PROTOCOL)

    # +----------------------------------+
    # |             Training             |
    # +----------------------------------+
    trainLosses = []
    validationLosses = []
    epochNumber = 0
    epochDisplay = 1
    while (epochNumber < parameters["epoque"]):
        epochNumber += 1
        epochLoss = 0
        model.train()
        trainLoss = torch.tensor(0).type(torch.DoubleTensor).to(device) # Compute the training loss in the GPU. In CPU, is slows down training by 3x
        for batchNumber, (xBatch, yBatch) in enumerate(training_generator):
            # print(f"\r\tBatch {batchNumber}", end='')

                # Prepare data
            xBatch = xBatch.type(torch.FloatTensor).to(device)
            yBatch = yBatch.type(torch.FloatTensor).to(device)

                # Optimize weigths
            optimizer.zero_grad()
            predictions = model(xBatch)
            batchLoss = loss(predictions, yBatch)
            batchLoss.backward()
            optimizer.step()
            trainLoss += batchLoss


        # Compute Train and Validation losses
        trainLoss = trainLoss.item() / batchNumber
        trainLosses.append(trainLoss)
        validationLoss = callback_computeValidationLoss(model)
        validationLosses.append(validationLoss)

        # Training message
        print(f"Epoch : {epochNumber} ; Train loss : {trainLoss} ; Val loss : {validationLoss}")

        # Training graph
        plot = plt.figure()
        xAxis = list(range(len(validationLosses)))
        plt.plot(xAxis, trainLosses, "r--o", label="TrainLoss")
        plt.plot(xAxis, validationLosses, "b--o", label="ValidationLoss")
        plt.legend()
        if (epochNumber == epochDisplay) :
            plt.savefig(f"{saveFolderPath}/loss_{str(epochNumber).zfill(5)}.png")
        plt.savefig(f"{saveFolderPath}/loss_last.png")
        plt.close()


        # Training log graph
        plot = plt.figure()
        plt.plot(xAxis, [math.log(trainLoss) for trainLoss in trainLosses], "r--o", label="TrainLoss")
        plt.plot(xAxis, [math.log(validationLoss) for validationLoss in validationLosses], "b--o", label="ValidationLoss")
        plt.legend()
        if (epochNumber == epochDisplay) :
            plt.savefig(f"{saveFolderPath}/logloss_{str(epochNumber).zfill(5)}.png")
        plt.savefig(f"{saveFolderPath}/logloss_last.png")
        plt.close()

        # +----------------------------------+
        # |              Saving              |
        # +----------------------------------+
        # Intermediary models
        if (epochNumber == epochDisplay) :
            torch.save(model.state_dict(), f"{saveFolderPath}/model_ep{str(epochNumber).zfill(5)}.pt")
            visualizeFolderPath = f"{saveFolderPath}/visualize_{str(epochNumber).zfill(5)}"
            Path(visualizeFolderPath).mkdir(parents=True, exist_ok=True)

            visualizeFolderPath_train = f"{visualizeFolderPath}/train"
            Path(visualizeFolderPath_train).mkdir(parents=True, exist_ok=True)
            callback_visualize_results(model, training_dataset, visualizeFolderPath_train)

            visualizeFolderPath_valid = f"{visualizeFolderPath}/valid"
            Path(visualizeFolderPath_valid).mkdir(parents=True, exist_ok=True)
            callback_visualize_results(model, validation_dataset, visualizeFolderPath_valid)

            visualizeFolderPath_test = f"{visualizeFolderPath}/test"
            Path(visualizeFolderPath_test).mkdir(parents=True, exist_ok=True)
            callback_visualize_results(model, test_dataset, visualizeFolderPath_test)

            epochDisplay = epochDisplay * 2
        # Final model
        torch.save(model.state_dict(), f"{saveFolderPath}/model_last.pt")

        # TODO : Also save the best performing model

    lowestValidationLoss = min(validationLosses)
    return lowestValidationLoss


"""
# +----------------------------------+
# |             Loading              |
# +----------------------------------+
model2 = UNet(n_channels=3, n_classes=1, bilinear=True)
model2.load_state_dict(torch.load(f"{saveFolderPath}/model_last.pt"))
model2.eval()
"""


if __name__ == "__main__" :
    main()
