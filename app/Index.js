function bookmarkFolders(urls)
{

}

function showPreviews()
{
    browser.previews = !browser.previews
    Maui.FM.setDirConf(browser.currentPath+"/.directory", "MAUIFM", "ShowThumbnail", browser.previews)
}

function showHiddenFiles()
{
    var state = Maui.FM.dirConf(browser.currentPath+"/.directory").hidden
    Maui.FM.setDirConf(browser.currentPath+"/.directory", "Settings", "HiddenFilesShown", !state)
    browser.refresh()
}

function createFolder()
{
    newFolderDialog.open()
}

function createFile()
{
    newFileDialog.open()
}

function bookmarkFolder()
{
    browser.bookmarkFolder([browser.currentPath])
}
