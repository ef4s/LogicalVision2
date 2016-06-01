/* Sampling module
 * ================================
 * Version: 2.0
 * Author: Wang-Zhou Dai <dai.wzero@gmail.com>
 */

#ifndef _SAMPLER_HPP
#define _SAMPLER_HPP

#include "../utils2/utils.hpp"

#include <opencv2/core/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>  // OpenCV window I/O
#include <armadillo>
#include <SWI-cpp.h>
#include <SWI-Prolog.h>

#include <iostream> // for standard I/O
#include <cstdlib>
#include <algorithm>
#include <string>   // for strings
#include <cmath>

using namespace std;
using namespace cv;

#define SWAP(a, b) {a = a + b; b = a - b; a = a - b;}

enum { XY_SHIFT = 16, XY_ONE = 1 << XY_SHIFT, DRAWING_STORAGE_BLOCK = (1 << 12) - 256 };

/********* declarations *********/

/* bound an local area in 3-d space and return the left/right up/down most
 *     points of the local area
 * @point: center
 * @radius: radius of the local area
 * @bound: boundary of the global space (> 0)
 * @return: left/right up/down most point of this area (grid)
 */
vector<Scalar> bound_scalar_3d(Scalar point, Scalar radius, Scalar bound);


/********* implementations *********/
double cv_img_var_loc(vector<Mat> *images, Scalar point, Scalar radius) {
    /// Apply Laplace function
    Mat img, abs_dst, dst;
    img = seq->at(vec[2]);
    int kernel_size = A3;
    int scale = 1;
    int delta = 0;
    int ddepth = CV_16S;

    Mat *grad_x, *grad_y;

    Sobel( img, grad_x, ddepth, 1, 0, 3, scale, delta, BORDER_DEFAULT );
    Sobel( img, grad_y, ddepth, 0, 1, 3, scale, delta, BORDER_DEFAULT );

    Mat orientation, magnitude;

    orientation = new Mat(1)

    for(int i = 0; i < vec[0]; i++){
        for(int j = 0; j < vec[1]; j++){
            orientation[i,j] = atan( grad_x[i,j] , grad_y->at(i, j)) * 180/(double)pi;
            magnitude(i,j) = sqrt( pow(dx(i,j),2) + pow(dy(i,j),2)
        }
    }

// return gradient
    double grad = 1.0;
    return A4 = PlTerm(grad);
}