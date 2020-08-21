# Index
Maui File manager

Index is a file manager that works on desktops, Android and Plasma Mobile.
Index lets you browse your system files and applications and preview your music, text, image and video files and share them with external applications.

## Prerequsites for developers
### Ubuntu

**GCC and Build Essentials**
sudo apt install build-essential
sudo apt install cmake

**Install extra-cmake-module >5.60**
```
git clone https://anongit.kde.org/extra-cmake-modules
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr .. && make
make install
```
**Install QT5 Libraries >5.10**
Download and install QT binaries from Qt Open Source
```
https://www.qt.io/cs/c/?cta_guid=074ddad0-fdef-4e53-8aa8-5e8a876d6ab4&placement_guid=99d9dd4f-5681-48d2-b096-470725510d34&portal_id=149513&canon=https%3A%2F%2Fwww.qt.io%2Fdownload-open-source&redirect_url=APefjpHQjssyGwlBYE-rW_TcMDvQTTSN3igs_sES0bNmU4j3dNgz_g7U1gRD5rU9XP6QCagDltYNZe1mC_6yuR-J9-W2YmcKATNxGjM6fTT48JNue9VuRi4DK7LXluTHxwtZRv8NK3hLkSNlk4AKqcxomUJZqosxV3GK0cryzQm5xtWguoQg5Sg-E3LLyWQcat5flnqFkP-N5WbMKOQiHXZCCFTtzz-R5-48fCOn5EOIYCa4ePXGI-SHM-vf3KokrwZ_5LPenmO7pMJaXlm5vEoa1VyWrurg3A&click=f8615a00-0c1d-4cfe-8af2-2090813f25fa&hsutk=f0a10f80ae5765dd6d56a9d6725ee662&signature=AAH58kGBEuTlcag57Ka07aFLDeEt5qyytQ&pageId=12602948080&__hstc=152220518.f0a10f80ae5765dd6d56a9d6725ee662.1595615134675.1595615134675.1595615134675.1&__hssc=152220518.12.1595615134675&__hsfp=256125709&contentType=standard-page
```

**Install KF5 Libraries**
Download and install KF5 Attica
```
Requeriment: Ubuntu 20.04 LTS (Focal)

sudo apt install libkf5attica-dev=5.68.0
```

## Build

### Dependencies
#### Qt core deps:
QT += qml, quick, sql

#### KF5 deps:
QT += KService KNotifications KI18n KIOCore KIOFileWidgets KIOWidgets KNTLM

#### Submodules

##### MauiKit:

https://invent.kde.org/kde/mauikit/

##### qmltermwidget:

https://github.com/Swordfish90/qmltermwidget

### Compilation

After all the dependencies are met you can throw the following command lines to build Index and test it

``` bash
git clone https://invent.kde.org/kde/index-fm.git --recursive

cd index-fm && mkdir build && cd build

cmake .. -DCMAKE_INSTALL_INSTALL_PREFIX=/usr -DQt5_DIR="/home/<username>/Qt/<Qt_Version>/gcc_64/lib/cmake/Qt5/"

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

![Preview](https://i.imgur.com/mqKgyNu.png)

![Preview](https://i.imgur.com/BrOiUCj.png)

![Preview](https://i.imgur.com/lphJtNs.png)

![Preview](https://i.imgur.com/a3R2rDo.png)
