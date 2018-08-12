from PIL import Image

if __name__ == '__main__':
    """
    im = Image.open('./assets/forest-bg/forest-bg.png')
    imw, imh = im.size

    index = 0
    for i in range(0, imw, 512):
        box = (i, 0, i + 512, imh)
        part = im.crop(box)
        part.save('./assets/forest-bg/forest-bg-%d.png' % index)
        index = index + 1"""

    im = Image.open('./assets/forest-fg/forest-fg.png')
    imw, imh = im.size

    index = 0
    for i in range(0, imw, 512):
        box = (i, 0, i + 512, imh)
        part = im.crop(box)
        part.save('./assets/forest-fg/forest-fg-%d.png' % index)
        index = index + 1
