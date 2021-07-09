import cv2
import numpy as np


def get_image_mask(input_img, hsv_lower, hsv_upper):
    # define the lower and upper boundaries of the "green"
    # ball in the HSV color space, then initialize the
    # list of tracked points
    # hsv_lower = (67, 0, 0)
    # hsv_upper = (86, 255, 255)

    hsv_img = cv2.cvtColor(input_img, cv2.COLOR_BGR2HSV)
    #cv2.imwrite("androhvs.jpeg", hsv_img)
    # construct a mask for the color "green", then perform
    # a series of dilations and erosions to remove any small
    # blobs left in the mask
    img_mask = cv2.inRange(hsv_img, hsv_lower, hsv_upper)

    return img_mask


def get_contours(input_img, min_contour_area=10.0):

    contour, hier = cv2.findContours(input_img, cv2.RETR_LIST, cv2.CHAIN_APPROX_SIMPLE)

    contour_info = []
    num_nonzeroarea_cnts = 0
    num_zeroarea_cnts = 0

    for c in contour:
        if cv2.contourArea(c) >= min_contour_area:
            num_nonzeroarea_cnts += 1
            # compute the center of the contour
            M = cv2.moments(c)
            cX = int(M["m10"] / M["m00"])
            cY = int(M["m01"] / M["m00"])

            contour_info.append(
                (
                    c,
                    np.array([[[cX, cY]]]),
                    cv2.isContourConvex(c),
                    cv2.contourArea(c),
                )
            )
        else:
            num_zeroarea_cnts += 1

    return contour_info


def draw_contours(
    input_img, contours_list, color=(0, 0, 255), thickness=1, debug=False
):
    output_img = input_img.copy()
    for idx, c_info in enumerate(contours_list):
        cv2.drawContours(output_img, [c_info[0]], 0, color, thickness)

    return output_img


def draw_contours_straight(
    input_img, contours_list, color=(0, 0, 255), thickness=1, debug=False
):
    output_img = input_img.copy()
    for idx, c_info in enumerate(contours_list):
        cv2.drawContours(output_img, [c_info], 0, color, thickness)

    return output_img


def load_centers(image_name):
    img = cv2.imread(image_name)
    mask = get_image_mask(img, (255, 255, 255), (255, 255, 255))
    contours = get_contours(mask, min_contour_area=1)

    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    # cv2.imwrite(f'{image_name}_grey.jpeg', gray)
    # cv.bilateralFilter() is highly effective in noise removal while keeping edges sharp
    blurred = cv2.bilateralFilter(gray, 5, 15, 15)
    canny_img = cv2.Canny(gray, 30, 150)
    # cv2.imwrite(f'{image_name}_canny.jpeg', canny_img)

    # edge detection filter
    kernel = np.array([[0.0, -1.0, 0.0], [-1.0, 5.0, -1.0], [0.0, -1.0, 0.0]])
    kernel = kernel / (np.sum(kernel) if np.sum(kernel) != 0 else 1)
    # filter the source image
    img_rst = cv2.filter2D(img, -1, kernel)
    # cv2.imwrite(f'{image_name}_hpass.jpeg', img_rst)
    ret, thresh_img = cv2.threshold(gray, 200, 255, cv2.THRESH_BINARY)
    # cv2.imwrite(f'{image_name}_thres.jpeg', thresh_img)

    contours = get_contours(thresh_img, min_contour_area=1)
    circles = draw_contours(mask, contours, color=(255, 255, 255), thickness=1)
    # cv2.imwrite(f'/tmp/tmp_circles.jpeg', circles)

    centers = list(map(lambda x: x[1], contours))
    centers = np.array(centers).reshape(len(centers), 2)

    sizes = np.array(list(map(lambda x: x[3], contours)))

    cimage = draw_contours_straight(
        mask,
        centers.reshape(len(centers), 1, 1, 2),
        color=(255, 255, 255),
        thickness=10,
    )
    # cv2.imwrite(f'{image_name}_centers.jpeg', cimage)

    return centers, sizes
