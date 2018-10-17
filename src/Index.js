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
