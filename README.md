# Index
Maui File manager

Index is a file manager that works on desktops, Android and Plasma Mobile.
Index lets you browse your system files and applications and preview your music, text, image and video files and share them with external applications.

# Developer Environment

We recommmend use KDE Neon for developing because KDE Neon has by default the latest version of Qt version supported in KDE Plasma.

Index-FM use Qt version 5.14.2 so we need this version or higer installed on ower host.

### **KDE Neon >= 5.19.4**

**Check libraries and other components**

1. Update the latest version of default OS libraries: **Open Discover and install all updates**
2. Check KDE Framework and Qt version installed: **Open System Preferenca > System Information**


**GCC and Build Essentials**

```
sudo apt-get update
sudo apt install cmake git
sudo apt install build-essential libgl1-mesa-dev qtdeclarative5-dev libqt5svg5-dev qtquickcontrols2-5-dev qt5-default libkdecorations2-dev qml-module-qtquick-shapes
```

**Install extra-cmake-module >5.60**
```
cd <path to download extra-cmake-modules>
git clone https://anongit.kde.org/extra-cmake-modules
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr .. && make
make install
```

**Install KF5 Libraries**
Download and install KF5 Attica
```
sudo apt install gettext
sudo apt install libkf5attica-dev libkf5kio-dev libkf5notifications-dev libkf5coreaddons-dev libkf5activities-dev libkf5i18n-dev libkf5declarative-dev libkf5plasma-dev libkf5syntaxhighlighting-dev
```
**Download and install MAUI KIT**

```
cd <path to download Maui>
git clone https://invent.kde.org/maui/mauikit.git
git checkout origin/development
cd mauikit && mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr .. && make
sudo make install
```
### **Other Host OS**

**Install QT5 Libraries >5.10**
Download and install QT binaries from Qt Open Source
```
https://www.qt.io/cs/c/?cta_guid=074ddad0-fdef-4e53-8aa8-5e8a876d6ab4&placement_guid=99d9dd4f-5681-48d2-b096-470725510d34&portal_id=149513&canon=https%3A%2F%2Fwww.qt.io%2Fdownload-open-source&redirect_url=APefjpHQjssyGwlBYE-rW_TcMDvQTTSN3igs_sES0bNmU4j3dNgz_g7U1gRD5rU9XP6QCagDltYNZe1mC_6yuR-J9-W2YmcKATNxGjM6fTT48JNue9VuRi4DK7LXluTHxwtZRv8NK3hLkSNlk4AKqcxomUJZqosxV3GK0cryzQm5xtWguoQg5Sg-E3LLyWQcat5flnqFkP-N5WbMKOQiHXZCCFTtzz-R5-48fCOn5EOIYCa4ePXGI-SHM-vf3KokrwZ_5LPenmO7pMJaXlm5vEoa1VyWrurg3A&click=f8615a00-0c1d-4cfe-8af2-2090813f25fa&hsutk=f0a10f80ae5765dd6d56a9d6725ee662&signature=AAH58kGBEuTlcag57Ka07aFLDeEt5qyytQ&pageId=12602948080&__hstc=152220518.f0a10f80ae5765dd6d56a9d6725ee662.1595615134675.1595615134675.1595615134675.1&__hssc=152220518.12.1595615134675&__hsfp=256125709&contentType=standard-page
```



# Build

### **Dependencies**

#### Qt core deps:
QT += qml, quick, sql

#### KF5 deps:
QT += KService KNotifications KI18n KIOCore KIOFileWidgets KIOWidgets KNTLM

### **Submodules**

### qmltermwidget:

https://github.com/Swordfish90/qmltermwidget

### **Build and run**

Before continue preparing your developer environment it is necesary preapare your Gitlab account for developer in your fork and update latest commits.

1. Register in https://identity.kde.org/index.php?r=registration/index
2. Log-In in https://invent.kde.org/ and look for Index-Fm
3. Press Fork Button
4. Go to you forked project and get URL (Press Button clone)


```bash
cd <path to download Maui>
git clone https://invent.kde.org/<username>/index-fm.git
cd index-fm
git config --global user.name "Your Invent KDE name"
git config --global user.email "Your Invent KDE email"
git remote add upstream https://invent.kde.org/maui/index-fm
git pull upstream
git checkout origin/development
git pull --rebase upstream development
```


### KDE Neon >=5.19.4

After all the dependencies are met you can throw the following command lines to build Index and test it

``` bash
mkdir build && cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr .. && make
```
### Other Host OS

``` bash
mkdir build && cd build

cmake -DCMAKE_INSTALL_INSTALL_PREFIX=/usr -DQt5_DIR="/home/<username>/Qt/<Qt_Version>/gcc_64/lib/cmake/Qt5/" -DMauiKit_DIR="/home/gabridc/Repositorio/KDE/mauikit/" ..

make

# you can now run index like this:
./bin/index

# or install it on your system:
sudo make install
```

A binary should be created and be ready to use.

## Contribute
If you like the Maui project or Index and would like to get involve ther are several ways you can join us.
- UI/UX design for desktop and mobile platforms
- Plasma, KIO and Baloo integration
- Deployment on other platforms like Mac OSX, IOS, Windows.. etc.
- Work on data analysis and on the tagging system
And also whatever else you would like to see on a convergent file manager.

You can get in touch with me by opening an issue or email me:
chiguitar@unal.edu.co


## Screenshots

![Preview](https://invent.kde.org/maui/index-fm/-/raw/v1.2/screenshots/Screenshot_1.png)

![Preview](https://invent.kde.org/maui/index-fm/-/raw/v1.2/screenshots/Screenshot_2.png)

![Preview](https://invent.kde.org/maui/index-fm/-/raw/v1.2/screenshots/Screenshot_3.png)

![Preview](https://invent.kde.org/maui/index-fm/-/raw/v1.2/screenshots/Screenshot_4.png)
