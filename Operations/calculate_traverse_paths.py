import cv2
import numpy as np
import scipy

import matplotlib as mpl
import matplotlib.pyplot as plt

from scipy.ndimage import shift

def extract_lines(filein):
    # white color mask
    img = cv2.imread(filein)
    #converted = convert_hls(img)
    image = cv2.cvtColor(img,cv2.COLOR_BGR2HLS)
    lower = np.uint8([0, 200, 0])
    upper = np.uint8([255, 255, 255])
    white_mask = cv2.inRange(image, lower, upper)
    # yellow color mask
    lower = np.uint8([10, 0,   100])
    upper = np.uint8([40, 255, 255])
    yellow_mask = cv2.inRange(image, lower, upper)
    # combine the mask
    mask = cv2.bitwise_or(white_mask, yellow_mask)
    result = img.copy()
    cv2.imshow("mask", mask) 
    return result

if __name__ == '__main__':
    filepath = "./traverse paths.png"
    extract_lines(filepath)
    image_matrix = cv2.imread(filepath, cv2.IMREAD_COLOR)
    (x_shape, y_shape, n_channels) = image_matrix.shape
    dx = x_shape / 2
    dy = y_shape / 2
    
    plt.imshow(image_matrix)
    plt.show()

    shifted_image = scipy.ndimage.shift(image_matrix, shift=dx)
    shifted_image = scipy.ndimage.shift(image_matrix, shift=dy)
    plt.imshow(image_matrix)
    plt.show()