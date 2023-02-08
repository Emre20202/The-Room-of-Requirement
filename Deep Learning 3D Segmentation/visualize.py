import torch
import pickle
import numpy as np
import matplotlib.pyplot as plt
import random



def show_images(images: list, path: str = f"_temp/testImage_{random.random()}.png") -> None:
    n: int = len(images)
    f = plt.figure()
    for i in range(n):
        # Debug, plot figure
        f.add_subplot(1, n, i + 1)
        plt.imshow(images[i])
    plt.savefig(path)
    plt.close()

def processPrediction(prediction):
  if (type(prediction) == torch.Tensor) :
      prediction = prediction.cpu().detach().numpy() # GPU -> CPU ; Detach training weights ; PyTorch -> Numpy
  prediction = (255.0 * prediction).astype("int")
  prediction = np.transpose(prediction, (1, 2, 0))

  if (prediction.shape[-1] == 1) : # Mask -> RGB black and white
      prediction = np.repeat(prediction, 3, axis=2)


  return prediction

def visualize(_model, _dataset, _device, folderPath = f"_temp"):
    params = {
        'batch_size': 8,
        'shuffle': False,
        'num_workers': 2
    }
    dataGenerator = torch.utils.data.DataLoader(_dataset, **params)
    for batchNumber, (xBatch, yBatch) in enumerate(dataGenerator):

            # Prepare data
        xBatch = xBatch.type(torch.FloatTensor).to(_device)
        yBatch = yBatch.type(torch.FloatTensor).to(_device)

            # Predict
        predictions = _model(xBatch)
        """
        print(f"xbatch_shape = {xBatch.shape}")
        print(f"ybatch_shape = {yBatch.shape}")
        print(f"predictions_shape = {predictions.shape}")
        """
        break

      # Display results of last batch
    for (x, pred, y) in zip(xBatch, predictions, yBatch):

      x = processPrediction(x)
      pred = processPrediction(pred)
      y = processPrediction(y)
      show_images([x, pred, y], path = f"{folderPath}/{random.random()}.png")

if __name__ == "__name__":
    modelPath = f"_data/2021y09m10d_10h18m31s178ms874ys/model_ep00016.pt"
    datasetPath = f"_data/2021y09m10d_10h18m31s178ms874ys/training_dataset.pkl"
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")


    # +----------------------------------+
    # |              Model               |
    # +----------------------------------+
    from UNetSigmoid import UNetSigmoid
    model = UNetSigmoid()
    model.to(device)
    model.eval()

    # +----------------------------------+
    # |               Data               |
    # +----------------------------------+
    with open(datasetPath, 'rb') as handle:
        dataset = pickle.load(handle)
    visualize(model, dataset, device)
