# Change Background Login Screen [Kali Linux 2020]

Actually it is not that difficult to change the background of the login screen in Kali Linux.
we just need to prepare an image that will be used as a background, and then run the script it will automatically create a login screen background on your kali linux.

### Screenshoot
![screenshoot](https://user-images.githubusercontent.com/58439463/85416825-20045500-b599-11ea-9cf3-65de03860bb5.png)

## TESTED:
* Kali Linux 2020.2 - [Desktop GNOME]

### How To Use :
Instructions on how to use the **Background Login Screen**:

```bash
git clone https://github.com/kp300/BACKGROUND-LOGIN-SCREEN.git
cd BACKGROUND-LOGIN-SCREEN
sudo chmod +x run.sh
sudo chmod +x back.sh
sudo bash run.sh
```

### Screenshoot
![background-login](https://user-images.githubusercontent.com/58439463/87871917-af592880-c9de-11ea-90dc-01732f456b2d.png)

### RESTORE TO DEFAULT BACKGROUND LOGIN SCREEN KALI LINUX:

```bash
sudo bash back.sh
```

