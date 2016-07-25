#include "draw.hpp"
#include "sampler.hpp"
#include "utils.hpp"
#include "memread.hpp"
#include "errors.hpp"
#include "lv_utils.cpp"

#include <opencv2/core/core.hpp>
#include "opencv2/imgproc/imgproc.hpp"
#include <opencv2/highgui/highgui.hpp>
#include <SWI-cpp.h>
#include <SWI-Prolog.h>

#include <iostream>

#include <algorithm> 
#include <functional>
#include <string>
#include <tgmath.h>
#include <math.h>

using namespace std;
using namespace cv;

///* gradient_point(+IMGSEQ, +[X, Y, Z], +KERNEL_SIZE, -GRAD)
// * get gradient of local area of point [X, Y, Z] in image sequence IMGSEQ
// */
//PREDICATE(sample_point, 3) {
//    char *p1 = (char*) A1;
//    vector<int> vec = list2vec<int>(A2, 3);
//    Scalar point(vec[0], vec[1], vec[2]); // coordinates scalar
//
//    // get image sequence and compute variance
//    const string add_seq(p1);
//    vector<Mat> *seq = str2ptr<vector<Mat>>(add_seq);
//
//}
//
/* gradient_seq(+IMGSEQ, +IMG, -Magnitude, -Direction)
 * get gradient of local area of point [X, Y, Z] in image sequence IMGSEQ
 */
PREDICATE(gradient_seq, 4) {
    char *p1 = (char*) A1;
    const string add_seq(p1);
    vector<Mat> *seq = str2ptr<vector<Mat>>(add_seq);

    int img = (int) A2;

    Mat src = seq->at(img);

    int scale = 1;
    int delta = 0;
    int ddepth = CV_64F;

    Mat grad_x, grad_y;
    Mat *grad = new Mat(src.size(), ddepth);
    Mat *ang = new Mat(src.size(), ddepth);

    Sobel(src, grad_x, ddepth, 1, 0, 3, scale, delta, BORDER_DEFAULT);
    Sobel(src, grad_y, ddepth, 0, 1, 3, scale, delta, BORDER_DEFAULT);
    //    cout << "Gradients Calculated" << endl;
    addWeighted(grad_x, 0.5, grad_y, 0.5, 0, *grad);
    //    cout << "Magnitudes Calculated" << endl;
    phase(grad_x, grad_y, *ang);
    //    cout << "Angles Calculated" << endl;

    string add_grad = ptr2str(grad);
    A3 = PlTerm(add_grad.c_str());
    string add_ang = ptr2str(ang);
    A4 = PlTerm(add_ang.c_str());
    return TRUE;
}

/* gradient_image(+IMGADD, -Magnitude, -Direction)
 * get gradient of local area of point [X, Y, Z] in image sequence IMGSEQ
 */
PREDICATE(gradient_image, 3) {
    char *p1 = (char*) A1;
    const string add_img(p1);
    Mat src = *str2ptr<Mat>(add_img);

    int scale = 1;
    int delta = 0;
    int ddepth = CV_64F;

    Mat grad_x, grad_y;
    Mat *grad = new Mat(src.size(), ddepth);
    Mat *ang = new Mat(src.size(), ddepth);

    GaussianBlur( src, src, Size(3,3), 0, 0, BORDER_DEFAULT );

    Mat src_gray;
    /// Convert it to gray
    cvtColor( src, src_gray, CV_BGR2GRAY );
//    cout << "Image Converted" << endl;
    Sobel(src_gray, grad_x, ddepth, 1, 0, 3, scale, delta, BORDER_DEFAULT);
    Sobel(src_gray, grad_y, ddepth, 0, 1, 3, scale, delta, BORDER_DEFAULT);
//    cout << "Gradients Calculated" << endl;
//    Sobel(src, grad_x, ddepth, 1, 0, 3, scale, delta, BORDER_DEFAULT);
//    Sobel(src, grad_y, ddepth, 0, 1, 3, scale, delta, BORDER_DEFAULT);
//    //    cout << "Gradients Calculated" << endl;
    addWeighted(grad_x, 0.5, grad_y, 0.5, 0, *grad);
//    //    cout << "Magnitudes Calculated" << endl;
    phase(grad_x, grad_y, *ang);
//    //    cout << "Angles Calculated" << endl;

//    Mat abs_grad_x, abs_grad_y, grad2;
//    convertScaleAbs( grad_x, abs_grad_x );
//    convertScaleAbs( grad_y, abs_grad_y );
//    phase(abs_grad_x, abs_grad_y, *ang);
//    addWeighted( abs_grad_x, 0.5, abs_grad_y, 0.5, 0, grad2 );
//    cout << "Gradients Added" << endl;

//    char* window_name = "Sobel Demo - Simple Edge Detector";
//    namedWindow( window_name, CV_WINDOW_AUTOSIZE );
//    imshow( window_name, grad2);

// 
//    cout << "Grad 2 has " << ang->channels() << " channels" << endl;    
//    for(int i = 0; i < ang->rows; i++){
//        for(int j = 0; j < ang->cols; j++){
//            int px = ang->at<double>(i,j) ;
////            if(px != NULL){ 
//                    cout << px << ",";
////            }
//        }
//        cout << "**" << endl;
//    }

//    char* window_name = "Sobel Demo - Simple Edge Detector";
//    namedWindow( window_name, CV_WINDOW_AUTOSIZE );
//    imshow( window_name, grad2);

//    waitKey(25);
    
    string add_grad = ptr2str(grad);
    A2 = PlTerm(add_grad.c_str());
    string add_ang = ptr2str(ang);
    A3 = PlTerm(add_ang.c_str());
    return TRUE;
}


/* resize_image(+IMGSEQ, +IMG, +[TARGET_SIZE_X, TARGET_SIZE_Y], -[RESIZED_IMAGE])
 * Resize an image
 */
PREDICATE(resize_image, 4) {
    char *p1 = (char*) A1;
    const string add_seq(p1);
    vector<Mat> *seq = str2ptr<vector<Mat>>(add_seq);

    int img = (int) A2;
    vector<int> target_sz = list2vec<int>(A3, 2);

    int ddepth = CV_16S;

    Mat grad;

    Mat *dst = new Mat(target_sz[0], target_sz[1], ddepth);

    int interpolation = CV_INTER_AREA;
    //cout << descale << ", " << 1 / descale << endl;
    //    resize(src, dst, Size(), 1/descale, 1/descale, interpolation);
    resize(seq->at(img), *dst, dst->size(), 0, 0, interpolation);

    string add = ptr2str(dst);
    return A4 = PlTerm(add.c_str());
}

/* diff_seq(+IMGSEQ, -DIFFSEQ)
 * difference an image sequence, REMEMBER TO RELEASE IT!
 */
PREDICATE(diff_seq, 2) {
    char *p1 = (char*) A1;
    const string add_seq(p1); // address
    vector<Mat> *seq = str2ptr<vector<Mat>>(add_seq);
    // copy image sequence
    vector<Mat> *newseq = new vector<Mat>();
    auto it = seq->begin();
    ++it;
    Mat first_img = seq->at(0);
    Mat diff_img;
    for (; it != seq->end(); ++it) {
        absdiff(first_img, *it, diff_img);
        newseq->push_back(diff_img.clone());
        first_img = *it;
    }
    string add = ptr2str(newseq);
    cout << add.c_str() << endl;
    return A2 = PlTerm(add.c_str());
}



/* sample_point(+IMGSEQ, +DIRSEQ, +POINT, -GRAD)
* Sample a point and return a gradient object
* @MAGSEQ = Address of the gradient magnitude sequence
* @DIRSEQ = Address of the gradient direction sequence
* @POINT = [X, Y, Z]: a point to sample
* @GRAD: returned point
*/
PREDICATE(sample_point, 4) {
    char *p1 = (char*) A1;
    const string mag_seq_add(p1); 
    vector<Mat> *mag_seq = str2ptr<vector<Mat>>(mag_seq_add);
    
    char *p2 = (char*) A2;
    const string dir_seq_add(p2); 
    vector<Mat> *dir_seq = str2ptr<vector<Mat>>(dir_seq_add);
    
    vector<int> loc = list2vec<int>(A3, 3);

    Mat mag = mag_seq->at(loc[2]);    
    Mat dir = dir_seq->at(loc[2]);    
    
	return A4 = vec2list(sample_point(mag,dir,loc));
}

/* sample_point_image(+MAGSEQ, +DIRSEQ, +POINT, -GRAD)
* Sample a point and return a gradient object
* @MAGSEQ = Address of the gradient magnitude sequence
* @DIRSEQ = Address of the gradient direction sequence
* @POINT = [X, Y, Z]: a point to sample
* @GRAD: returned point
*/
PREDICATE(sample_point_image, 4) {
    char *p1 = (char*) A1;
    const string mag_seq_add(p1); 
    Mat mag = *str2ptr<Mat>(mag_seq_add);
    
    char *p2 = (char*) A2;
    const string dir_seq_add(p2); 
    Mat dir = *str2ptr<Mat>(dir_seq_add);

    vector<int> loc = list2vec<int>(A3, 3);

	return A4 = vec2list(sample_point(mag,dir,loc));
}


///* sample_line_to_point(+IMGSEQ, +POINT, +DIR, +BOUND, +THRESHOLD, -Point)
// * Sample along a line until you reach the first point with gradient above threshold
// * @IMGSEQ = Address of image sequence
// * @POINT = [X, Y, Z]: a point that the line crosses
// * @DIR = [DX, DY, DZ]: direction of the line
// * @BOUND = [W, H, D]: size limit of the video (width, height and duration),
// *                     usually obtained from 'size_3d(VID, W, H, D)'
// * @POINT: returned point
// */
//PREDICATE(sample_line_to_point, 6) {
//    char *p1 = (char*) A1;
//    const string add_seq(p1); // address
//    vector<Mat> *seq = str2ptr<vector<Mat>>(add_seq);
//
//    vector<int> s_vec = list2vec<int>(A2, 3);
//    Scalar start(s_vec[0], s_vec[1], s_vec[2]);
//    Scalar current(s_vec[0], s_vec[1], s_vec[2]);
//
//    s_vec = list2vec<int>(A3, 3);
//    Scalar dir(s_vec[0], s_vec[1], s_vec[2]);
//
//    s_vec = list2vec<int>(A4, 3);
//    Scalar bound(s_vec[0], s_vec[1], s_vec[2]);
//
//    //Follow along the line until you find a gradient that exceeds threshold
//    double grad = 0;
//    double thresh = (double) A5;
//
////    while(grad < thresh || (current[0]){
////
////
////    }
//
//
//}


///* fit_rectangle(+POINTS, -RECTANGLE)
// * Sample along a line until you reach the first point with gradient above threshold
// * @POINT = [X, Y, Z]: a list of points of interest
// * @RECTANGLE = the rectangle that closes the set of points
// */
//PREDICATE(fit_rectangle, 2) {

//    vector<Scalar> points = point_list2vec(A1);
//    RotatedRect box = minAreaRect(Mat(points));
//    vector<double> box_param = (box.center, box.size[0], box.size[1], box.angle);

//    return A2  = vec2list<double>(box_param);
//}


///* noisy_line(+START, +END, +IMGSEQ, +DIRSEQ)
// * Samples points and checks if they're correct with a set probabilty   
// * @POINTS = [[X, Y]]: a list of points of interest
// * @RECTANGLE = the rectangle that closes the set of points
// */
//PREDICATE(noisy_line, 4){
//    vector<int> start = list2vec<int>(A1, 3);
//    vector<int> end = list2vec<int>(A2, 3);
//    vector<int> diff = vec_subtract(start, end);    
//    
//    char *p1 = (char*) A3;
//    const string mag_seq_add(p1); 
//    vector<Mat> *mag_seq = str2ptr<vector<Mat>>(mag_seq_add);

//    char *p2 = (char*) A4;
//    const string dir_seq_add(p2); 
//    vector<Mat> *dir_seq = str2ptr<vector<Mat>>(dir_seq_add);

//    vector<double> start_dir_mag = get_dir_mag(dir_seq, mag_seq, start);

//    //Sample n points along the target line
//    //from k subsets of size q, if the number of sucesses is above p then return true
//    int len = (int)vec_len(diff);
//        
//    double EPSILON = 0.1;
//    double THRESHOLD = 0.9;
//    double NOISE_ESTIMATE = 0.2;
//    int K = len * (EPSILON / NOISE_ESTIMATE);  
//    int q = K * (1 - NOISE_ESTIMATE);
//    int p = 0;
//    
//    random_device rd;
//    mt19937 gen(rd());
//    uniform_int_distribution<> dis(0, len);
//    for(int i = 0; i < K; i++){
//        int r = dis(gen);
//        vector<int> loc = start;
//        for(int i = 0; i < 3; i++){
//            loc[i] += r * (diff[i] / len);
//        }      
//        
//        vector<double> t_dir_mag = get_dir_mag(dir_seq, mag_seq, loc);
//        
//        if((start_dir_mag[0] == t_dir_mag[0]) && (t_dir_mag[1] > THRESHOLD)){
//            p++;
//        }
//    }
//    
//    if(p >= q){
//        return TRUE;
//    }else{
//        return FALSE;
//    }   
//}


/* noisy_line_image(+START, +END, +MAG, +DIR)
 */
PREDICATE(noisy_line_image, 4){
    vector<int> start = list2vec<int>(A1, 3);
    vector<int> end = list2vec<int>(A2, 3);
    
    char *p1 = (char*) A3;
    const string mag_add(p1); 
    Mat *mag = str2ptr<Mat>(mag_add);

    char *p2 = (char*) A4;
    const string dir_add(p2); 
    Mat *dir = str2ptr<Mat>(dir_add);
    
    if(noisy_line(start, end, mag, dir)){
        return TRUE;
    }else{
        return FALSE;
    }   
}



/* noisy_extend_line(+START, +END, +IMGSEQ, +DIRSEQ, +MAX_SIZE, -NEW_START, -NEW_END)
 * Samples points and checks if they're correct with a set probabilty
 * @POINTS = [[X, Y]]: a list of points of interest
 * @RECTANGLE = the rectangle that closes the set of points
 */
PREDICATE(noisy_extend_line, 7){
    vector<int> start = list2vec<int>(A1, 3);
    vector<int> end = list2vec<int>(A2, 3);
    vector<int> diff = vec_subtract(start, end);
    int len = sqrt(diff[0] + diff[1] + diff[2]);

    char *p1 = (char*) A3;
    const string mag_seq_add(p1); 
    vector<Mat> *mag_seq = str2ptr<vector<Mat>>(mag_seq_add);

    char *p2 = (char*) A4;
    const string dir_seq_add(p2); 
    vector<Mat> *dir_seq = str2ptr<vector<Mat>>(dir_seq_add);

    vector<double> start_dir_mag = get_dir_mag(dir_seq, mag_seq, start);

    //Sample n points along the target line
    //from k subsets of size q, if the number of sucesses is above p then return true
    double EPSILON = 0.1;
    double THRESHOLD = 0.9;
    double NOISE_ESTIMATE = 0.2;
    int K = len * (EPSILON / NOISE_ESTIMATE);  
    int q = K * (1 - NOISE_ESTIMATE);
    int p = 0;
    
    //use a window, stop when it falls to below the target value
    bool valid = true;
    vector<int>new_start = list2vec<int>(A1, 3);
    vector<bool>valid_counts(K);
    
    for(int k = 0; k < K; k++){
        //cycle through one step at a time
        for(int j = 0; j < 3; j++){
            new_start[j] += (k - (K / 2)) * (diff[j] / len);
        }
        
        vector<double> t_dir_mag = get_dir_mag(dir_seq, mag_seq, new_start);        
                
        if((start_dir_mag[0] == t_dir_mag[0]) && (t_dir_mag[1] > THRESHOLD)){
            p++;
            valid_counts[k] = true;
        }else{
            valid_counts[k] = false;
        }
    }
    
    int i = 1;
    while(valid){
        //cycle through one step at a time
        for(int j = 0; j < 3; j++){
            new_start[i] += i * (diff[j] / len);
        }
        
        bool new_valid_point = false;
        
        vector<double> t_dir_mag = get_dir_mag(dir_seq, mag_seq, new_start);        
        
        if((start_dir_mag[0] == t_dir_mag[0]) && (t_dir_mag[1] > THRESHOLD)){
            p++;
            new_valid_point = true;
        }
        if(!valid_counts[i % K] && new_valid_point){
            p++;
        }else{
            p--;
        }
        
        valid_counts[i % K] = new_valid_point;
        
        valid = p > q;
    }
    
    // The terminal new_end value is the best edge estimate
    valid = true;
    vector<int>new_end = list2vec<int>(A2, 3);
    
    for(int k = 0; k < K; k++){
        //cycle through one step at a time
        for(int j = 0; j < 3; j++){
            new_end[i] += (k - (K / 2)) * (-diff[j] / len);
        }
        
        vector<double> t_dir_mag = get_dir_mag(dir_seq, mag_seq, new_end);        
                
        if((start_dir_mag[0] == t_dir_mag[0]) && (t_dir_mag[1] > THRESHOLD)){
            p++;
            valid_counts[k] = true;
        }else{
            valid_counts[k] = false;
        }
    }

    
    while(valid){
        //cycle through one step at a time
        for(int j = 0; j < 3; j++){
            new_end[i] += i * (diff[j] / len);
        }
        
        vector<double> t_dir_mag = get_dir_mag(dir_seq, mag_seq, new_end);        
        
        bool new_valid_point = false;
        if((start_dir_mag[0] == t_dir_mag[0]) && (t_dir_mag[1] > THRESHOLD)){
            p++;
            new_valid_point = true;
        }
        if(!valid_counts[i % K] && new_valid_point){
            p++;
        }else{
            p--;
        }
        
        valid_counts[i % K] = new_valid_point;
        
        valid = p > q;
    }
    
    vector<double> double_start(new_start.begin(), new_start.end());            
    A6 = vec2list(double_start);
    vector<double> double_end(new_end.begin(), new_end.end());
    A7 = vec2list(double_end);
    return TRUE;
}

