<!-- source: https://docs.hyva.io/hyva-commerce/features/image-editor/features.html -->

# Image Editor Backup Features

Image Editor is build upon a forked version of Filerobot Image Editor.

See [Filerobot Image Editor Github page](https://github.com/scaleflex/filerobot-image-editor) for a demo and the default features provided.

## Save and Save As

When you edit your image the first time with Image Editor, the save button will have 2 options to select:

![Save unfold](images/image-editor-save.png)

1. Option `Save` will save your image with the same filename. On your first save, Image Editor will backup the image.
2. Option `Save as` will save your image in a new file, with the provided name. If a file with the same name already exists, Image Editor will add a suffix with a number, such as `_1`. This option might be useful for content creators who want to make variants of the same image (narrow, wide, mobile, etc.)

![Save as](images/image-editor-save-as.png)

## Image backup

If you save your file with `Save as`, a backup is not created.

After the first `Save,` the save menu will have a `Restore from backup` option. Clicking this option will revert all changes you made to the image and restore the file to its original state.

![Restore](images/image-editor-restore.png)
