function bookmarkFolder(path)
{
    if(inx.isDefaultPath(path)) return

    inx.bookmark(path)
    placesSidebar.populate()
}
