# Index
Maui File manager

Index is a file manager that works on desktops, Android and Plasma Mobile.
Index lets you browse your system files and applications and preview your music, text, image and video files and share them with external applications.

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

cmake .. -DCMAKE_INSTALL_INSTALL_PREFIX=/usr

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
