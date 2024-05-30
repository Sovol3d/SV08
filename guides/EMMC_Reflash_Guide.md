# EMMC Reflashing Guide

> [!IMPORTANT]
> You need a [MKS EMMC adapter](https://amzn.to/4bVAMLA)[^1] to reflash this printer.


1. [Download the latest image file from sovol.](https://drive.google.com/drive/folders/10CdLCMd5jGHhtjPqmnJGEteK2nnGQku2?usp=sharing)
2. [Download Balena Etcher for your OS.](https://etcher.balena.io/#download-etcher)
3. Unscrew and remove the EMMC Chip from the motherboard of your printer.
4. Plug the EMMC module into the adapter
5. Plug the adapter into your computer
6. Open Etcher
    1. Select Flash from File.
        * H616_2.3.3_debian_sovol-2.3.3.img Or similar
    2. Select your Adapter
    3. Click Flash!
7. Once this process has finished unplug the adapter from your PC.
8. Unplug the EMMC from the adapter
9. Plug it back into the printer and replace the two screws.

After this is complete, your printer should act like how the printer arrived from the factory.


[^1]: I earn commissions from this link.
