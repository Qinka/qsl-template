from typing import *
import typer
import cv2
import numpy as np
import os

app = typer.Typer()

def draw_text(image: np.ndarray, text: str) -> np.ndarray:
    height, width, *_ = image.shape
    off = int(min(height, width) * 0.1)
    pos = (off, int(0.9 * height)) # if width > height else (off, 12* off)
    cv2.putText(image, text, pos, cv2.FONT_HERSHEY_TRIPLEX, int(off * 0.04), (255, 255, 255), int(off * 0.2), cv2.LINE_AA, bottomLeftOrigin=False)
    cv2.putText(image, text, pos, cv2.FONT_HERSHEY_TRIPLEX, int(off * 0.04), (0, 0, 0), int(off * 0.1), cv2.LINE_AA, bottomLeftOrigin=False)
    return image

def image_process(image: np.ndarray, callsign: str = 'N0CALL') -> np.ndarray:
    height, width, *_ = image.shape
    image = draw_text(image, f'DE {callsign}'.upper())
    if height > width:
        image = np.rot90(image, 1)
        # image = cv2.transpose(image)

    height, width, *_ = image.shape
    if width / height > 10/7:
        size = int(height / 7 * 10)
        diff = (width - size) // 2
        image = image[:, diff: diff+size]
    else:
        size = int(height / 10 * 7)
        diff = (height - size) // 2
        image = image[diff: diff+size, width]

    # cv2.imshow('display', image)
    # cv2.waitKey(0)
    return image

@app.command()
def main(
    src: Annotated[str, typer.Option('-src', help='source folder')],
    dest: Annotated[str, typer.Option('-dest', help='dest folder')],
    callsign: Annotated[str, typer.Option('-callsign', help='dest folder')] = 'N0CALL',
):

    os.makedirs(dest, exist_ok=True)

    for file in sorted(os.listdir(src)):
        try:
            print(os.path.join(src, file))
            image = cv2.imread(os.path.join(src, file))
            image = image_process(image, callsign)
            cv2.imwrite(os.path.join(dest, file), image)
            print(os.path.join(dest, file))
        except KeyboardInterrupt:
            exit(1)
        except BaseException as e:
            print(e)

if __name__ == '__main__':
    app()



