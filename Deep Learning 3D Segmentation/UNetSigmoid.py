import torch
from PytorchUNet.unet import UNet


class UNetSigmoid(torch.nn.Module):
    def __init__(self):
        super(UNetSigmoid, self).__init__()
        self.model = UNet(n_channels=3, n_classes=1, bilinear=True)
        self.sigmoid=torch.nn.Sigmoid()
    def forward(self, x):
        x=self.model(x)
        return self.sigmoid(x)

if (__name__ == "__main__"):
    model = UNetSigmoid()
    print(model)
