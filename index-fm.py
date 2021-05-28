import info
from Package.CMakePackageBase import *


class subinfo(info.infoclass):
    def setTargets(self):
        self.svnTargets['master'] = 'https://invent.kde.org/maui/index-fm.git'

        for ver in ['1.2.2']:
            self.targets[ver] = 'https://download.kde.org/stable/maui/index/1.2.2/index-fm-%s.tar.xz' % ver
            self.archiveNames[ver] = 'index-fm-%s.tar.gz' % ver
            self.targetInstSrc[ver] = 'index-fm-%s' % ver

        self.description = "Browse, organize and preview your files."
        self.defaultTarget = '1.2.2'

    def setDependencies(self):
        self.runtimeDependencies["virtual/base"] = None
        self.runtimeDependencies["libs/qt5/qtbase"] = None
        self.runtimeDependencies["kde/maui/mauikit-filebrowsing"] = None
        self.runtimeDependencies["kde/maui/mauikit-texteditor"] = None
        self.runtimeDependencies["kde/maui/mauikit-imagetools"] = None
        self.runtimeDependencies["kde/maui/mauikit"] = None


class Package(CMakePackageBase):
    def __init__(self, **args):
        CMakePackageBase.__init__(self)
