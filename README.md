# Introduction

This repo servers to better assist users with modifying the SV08 printer.
This repo also will eventually include guides that sovol declined to have made


All text in blocks like below are taken directly from Sovols SV08 Repo
> Quote blocks like this



# 
This is sovols official response when asked if merges would be considered for the github. [Email response from sovol of them declining to have changes merged to the github.](images/ghresponse.png)


# To Do

- [ ] Make list
- [ ] 2
- [ ] 3


# Notice

Sovol will NOT give you support if you modify ANY files on your printer. this includes tuning. before you email sovol for support you must follow the factory reset guide or Re-flash the EMMC.

> This is the official source code for Sovol SV08. The damage caused by modifying firmware also using the third party firmware will lose the 1 year warranty. If you need support, it’s recommended to reflash the stock firmware before contacting sovol.

> Sovol doesn’t provide tech help for help users to modify source code, but if you need us to add more functions, you are welcome to send us your suggestions via Facebook Messenger or email 
info@sovol3d.com


# Official Links

* Product Page: https://www.sovol3d.com/products/sovol-sv08-3d-printer
* SV08 Wiki: https://wiki.sovol3d.com/en/SV08
* Firmware: https://drive.google.com/drive/folders/1QGeGrXtf-aVuC341sM102vSQTVu2bvZ3?usp=sharing
* Image file (Follow the Reflashing Guide): https://drive.google.com/drive/folders/10CdLCMd5jGHhtjPqmnJGEteK2nnGQku2?usp=sharing
* Orcaslicer Profiles: https://drive.google.com/drive/folders/1KWjLxwpO_9_Xqi_f6qu84HRxZi26a_GN?usp=sharing
* Files that came on the USB: https://drive.google.com/drive/folders/1MqC0QyXXDqqR__qIxysjTG5eevuNQv5i?usp=sharing








# Setting Up KIAUH

if for some reason kiauh needs to be reinstalled. you *should consider* using Sovols version of klipper to avoid errors. The updated address is [Sovol-klipper](https://github.com/Sovol3d/klipper)


> How to update klipper
> - ssh log in:sovol ;password:sovol
> - cd kiauh
> - ./kiauh.sh
> - input Perform action: 3 and Remove klipper
> - back and install klipper