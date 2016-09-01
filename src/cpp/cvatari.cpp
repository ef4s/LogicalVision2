#include "draw.hpp"
#include "sampler.hpp"
#include "utils.hpp"
#include "memread.hpp"
#include "errors.hpp"
#include "lv_utils.cpp"

#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <SWI-cpp.h>
#include <SWI-Prolog.h>

#include <stdlib.h>
#include <stdio.h>
#include <iostream>

#include <algorithm> 
#include <functional>
#include <string>
#include <tgmath.h>
#include <math.h>
#include <limits>

using namespace std;
using namespace cv;

/* gradient_seq(+IMGSEQ, -Magnitude, -Direction)
 * get gradient of an image sequence IMGSEQ
 */
PREDICATE(gradient_seq, 3) {
    char *p1 = (char*) A1;
    const string add_seq(p1);
    vector<Mat*> *seq = str2ptr<vector<Mat*>>(add_seq);
    vector<Mat*> *mag_seq = new vector<Mat*>();
    vector<Mat*> *dir_seq = new vector<Mat*>();
    int ddepth = CV_64F;

    for(vector<Mat*>::iterator src = seq->begin(); src != seq->end(); src++){  
    
        Mat *mag = new Mat((*src)->size(), ddepth);
        Mat *dir = new Mat((*src)->size(), ddepth);

        gradient_image(*src, mag, dir);

        mag_seq->push_back(mag);
        dir_seq->push_back(dir);
    }

    string add_mag = ptr2str(mag_seq);
    A2 = PlTerm(add_mag.c_str());

    string add_dir = ptr2str(dir_seq);
    A3 = PlTerm(add_dir.c_str());

    return TRUE;
}

/* gradient_image(+IMGADD, -Magnitude, -Direction)
 * get gradient of local area of point [X, Y, Z] in image sequence IMGSEQ
 */
PREDICATE(gradient_image, 3) {
    char *p1 = (char*) A1;
    const string add_img(p1);
    Mat *src = str2ptr<Mat>(add_img);
    
    int ddepth = CV_64F;
    
    Mat *mag = new Mat(src->size(), ddepth);
    Mat *dir = new Mat(src->size(), ddepth);

    gradient_image(src, mag, dir);
        
//    cout << "BACK HERE" << endl;
    string add_mag = ptr2str(mag);
    A2 = PlTerm(add_mag.c_str());
//    cout << "Mag address: " << mag << endl;

    string add_dir = ptr2str(dir);
    A3 = PlTerm(add_dir.c_str());
//    cout << "Dir address: " << dir << endl;

    return TRUE;
}

/* gradient_image(+IMGADD, -Magnitude, -Direction)
 * get gradient of local area of point [X, Y, Z] in image sequence IMGSEQ
 */
PREDICATE(show_gradient_image, 1) {
    char *p1 = (char*) A1;
    const string add_img(p1);
    Mat *src = str2ptr<Mat>(add_img);
    
    Mat src_gray;
    Mat grad;
    string window_name = "Sobel Demo - Simple Edge Detector";
    int scale = 1;
    int delta = 0;
    int ddepth = CV_16S;

    /// Load an image
//    GaussianBlur( *src, *src, Size(3,3), 0, 0, BORDER_DEFAULT );

    /// Convert it to gray
    cvtColor( *src, src_gray, CV_BGR2GRAY );

    /// Create window
    namedWindow( window_name, WINDOW_NORMAL );

    /// Generate grad_x and grad_y
    Mat grad_x, grad_y;
    Mat abs_grad_x, abs_grad_y;

    /// Gradient X
    //Scharr( src_gray, grad_x, ddepth, 1, 0, scale, delta, BORDER_DEFAULT );
    Sobel( src_gray, grad_x, ddepth, 1, 0, 3, scale, delta, BORDER_DEFAULT );
    convertScaleAbs( grad_x, abs_grad_x );

    /// Gradient Y
    //Scharr( src_gray, grad_y, ddepth, 0, 1, scale, delta, BORDER_DEFAULT );
    Sobel( src_gray, grad_y, ddepth, 0, 1, 3, scale, delta, BORDER_DEFAULT );
    convertScaleAbs( grad_y, abs_grad_y );

    /// Total Gradient (approximate)
    double alpha = 10.0;
    int beta = -5;
    addWeighted( abs_grad_x, 0.5, abs_grad_y, 0.5, 0, grad );

//    Mat grad_bright = Mat::zeros( grad.size(), grad.type() );

    for(int i = 0; i < 10; i++){    
        grad.convertTo(grad, -1, alpha, beta);
        grad.convertTo(grad, -1, 1/alpha, 0);
        GaussianBlur(grad, grad, Size(3,3), 0, 0, BORDER_DEFAULT);
    }
    
    grad.convertTo(grad, -1, alpha, beta);
    
    
//    for(int i = 0; i < 10; i++){    
//        GaussianBlur(src_gray, src_gray, Size(3,3), 0, 0, BORDER_DEFAULT);
//    }
    
    
    
//    imshow( window_name, grad );
    imshow( window_name, src_gray );        
    waitKey(0); 
    destroyWindow(window_name);
    
    return TRUE;
}



/* blur_image(+IMG_SEQ_ADD, +STEP_SIZE, -BLURRED_IMAGE)
 * Applies guassian blurring to an image sequence
 */
PREDICATE(blur_seq, 3) {
    char *p1 = (char*) A1;
    const string add_seq(p1);
    vector<Mat> *seq = str2ptr<vector<Mat>>(add_seq);
    vector<Mat*> *blurred_seq = new vector<Mat*>();
    int step_size = (int) A2;

    for(vector<Mat>::iterator src = seq->begin(); src != seq->end(); src++){    
        Mat *blurred = new Mat(src->clone());

        blur_image(&(*src), step_size, blurred);
        
//        cout << "src: " << src->rows << ", " << src->cols;
//        cout << ", mat: " << blurred->rows << ", " << blurred->cols << endl;
        
        blurred_seq->push_back(blurred);
    }

//    cout << "vid seq len: " << seq->size() << endl;
//    cout << "blurred seq len: " << seq->size() << endl;

    string add_blur = ptr2str(blurred_seq);
    A3 = PlTerm(add_blur.c_str());

//    cout << "BLURRING DONE" << endl;
    
    return TRUE;
}


/* blur_image(+IMG_SEQ_ADD, +STEP_SIZE, -BLURRED_IMAGE)
 * Applies guassian blurring to an image sequence
 */
PREDICATE(blur_seq_ptr, 3) {
    char *p1 = (char*) A1;
    const string add_seq(p1);
    vector<Mat*> *seq = str2ptr<vector<Mat*>>(add_seq);
    vector<Mat*> *blurred_seq = new vector<Mat*>();
    
    int step_size = (int) A2;

    for(vector<Mat*>::iterator src = seq->begin(); src != seq->end(); src++){    
        Mat *blurred = new Mat((*src)->clone());

        blur_image(*src, step_size, blurred);
        
//        cout << "src: " << src->rows << ", " << src->cols;
//        cout << ", mat: " << blurred->rows << ", " << blurred->cols << endl;
        
        blurred_seq->push_back(blurred);
    }

//    cout << "vid seq len: " << seq->size() << endl;
//    cout << "blurred seq len: " << seq->size() << endl;

    string add_blur = ptr2str(blurred_seq);
    A3 = PlTerm(add_blur.c_str());

//    cout << "BLURRING DONE" << endl;
    
    return TRUE;
}

/* image sequence bounds(+IMGSEQ, -BOUNDS)
 * Find out bounds of an image sequence
 */
PREDICATE(imgseq_bounds, 2) {
    char *p1 = (char*) A1;
    const string add_seq(p1);
    vector<Mat> *seq = str2ptr<vector<Mat>>(add_seq);
    
    Mat m = seq->at(0);
    
    vector<double> v = {(double)m.rows,(double)m.cols,(double)seq->size()};
	return A2 = vec2list(v); 
}

/* image sequence bounds(+IMGSEQ, -BOUNDS)
 * Find out bounds of an image sequence
 */
PREDICATE(imgseq_ptr_bounds, 2) {
    char *p1 = (char*) A1;
    const string add_seq(p1);
    vector<Mat*> *seq = str2ptr<vector<Mat*>>(add_seq);
    
    Mat *m = seq->at(0);
    
    vector<double> v = {(double)m->rows,(double)m->cols,(double)seq->size()};
	return A2 = vec2list(v); 
}

/* resize_image(+IMGSEQ, +IMG, +[TARGET_SIZE_X, TARGET_SIZE_Y], -[RESIZED_IMAGE])
 * Resize an image
 */
PREDICATE(resize_image, 4) {
    char *p1 = (char*) A1;
    const string add_seq(p1);
    vector<Mat> *seq = str2ptr<vector<Mat>>(add_seq);

    int img = (int) A2;
 
//    cout << "seq len: " << seq->size() << endl;
 
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


/* resize_image(+IMG_SEQ_ADD, +BLUR_SIZE, +STEP_SIZE, -BLURRED_IMAGE)
 * Resizes images in an image sequence
 */
PREDICATE(resize_seq, 4) {
    char *p1 = (char*) A1;
    const string add_seq(p1);
    vector<Mat> *seq = str2ptr<vector<Mat>>(add_seq);
    vector<Mat*> *resized_seq = new vector<Mat*>();
    
    int blur_size = (int) A2;
    vector<int> target_sz = list2vec<int>(A3, 2);
    
    int ddepth = CV_64F;

    for(vector<Mat>::iterator src = seq->begin(); src != seq->end(); src++){    
        Mat *resized = new Mat(target_sz[0], target_sz[1], ddepth);
        resize(*src, *resized, resized->size(), 0, 0, CV_INTER_AREA);

        Mat *blurred = new Mat(resized->clone());
        blur_image(resized, blur_size, blurred);

//        Mat *blurred = new Mat(src->clone());
        resized_seq->push_back(blurred);
    }

    string add_resized = ptr2str(resized_seq);
    A4 = PlTerm(add_resized.c_str());

//    cout << "BLURRING DONE" << endl;
    
    return TRUE;
}


/* diff_seq(+IMGSEQ, -IMGSEQ_PTR)
 * convert an image sequence to matrix of pointers, REMEMBER TO RELEASE IT!
 */
PREDICATE(img_seq2ptr, 2) {
    char *p1 = (char*) A1;
    const string add_seq(p1); // address
    vector<Mat> *seq = str2ptr<vector<Mat>>(add_seq);
    // copy image sequence
    vector<Mat*> *newseq = new vector<Mat*>();
    
    for (auto it = seq->begin(); it != seq->end(); ++it) {
        newseq->push_back(new Mat(it->clone()));
    }
    string add = ptr2str(newseq);
    return A2 = PlTerm(add.c_str());
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
    return A2 = PlTerm(add.c_str());
}



/* sample_point(+POINT,+MAGSEQ, +DIRSEQ,  -GRAD)
* Sample a point and return a gradient object
* @MAGSEQ = Address of the gradient magnitude sequence
* @DIRSEQ = Address of the gradient direction sequence
* @POINT = [X, Y, Z]: a point to sample
* @GRAD: returned point
*/
PREDICATE(sample_point, 4) {
    vector<int> loc = list2vec<int>(A1, 3);
    
    char *p1 = (char*) A2;
    const string mag_seq_add(p1); 
    vector<Mat*> *mag_seq = str2ptr<vector<Mat*>>(mag_seq_add);
    Mat mag = *(mag_seq->at(loc[2]));
    
    char *p2 = (char*) A3;
    const string dir_seq_add(p2); 
    vector<Mat*> *dir_seq = str2ptr<vector<Mat*>>(dir_seq_add);
    Mat dir = *(dir_seq->at(loc[2]));    
    
	return A4 = vec2list(sample_point(loc,mag,dir));
}

/* sample_point_image(+MAGSEQ, +DIRSEQ, +POINT, -GRAD)
* Sample a point and return a gradient object
* @MAGSEQ = Address of the gradient magnitude sequence
* @DIRSEQ = Address of the gradient direction sequence
* @POINT = [X, Y, Z]: a point to sample
* @GRAD: returned point
*/
PREDICATE(sample_point_image, 4) {
    vector<int> loc = list2vec<int>(A1, 3);

    char *p1 = (char*) A2;
    const string mag_add(p1); 
    Mat mag = *str2ptr<Mat>(mag_add);
    
    char *p2 = (char*) A3;
    const string dir_add(p2); 
    Mat dir = *str2ptr<Mat>(dir_add);

	return A4 = vec2list(sample_point(loc,mag,dir));
}


/* noisy_line(+START, +END, +IMGSEQ, +DIRSEQ,+THRESHOLD)
 * Samples points and checks if they're correct with a set probabilty   
 * @POINTS = [[X, Y]]: a list of points of interest
 * @RECTANGLE = the rectangle that closes the set of points
 */
PREDICATE(noisy_line, 5){
    vector<int> start = list2vec<int>(A1, 3);
    vector<int> end = list2vec<int>(A2, 3);
    
    if(start[2] != end[2]) {
        return FALSE;
    }
    
    char *p1 = (char*) A3;
    const string mag_seq_add(p1); 
    vector<Mat*> *mag_seq = str2ptr<vector<Mat*>>(mag_seq_add);
    Mat *mag = mag_seq->at(start[2]);    
        
    char *p2 = (char*) A4;
    const string dir_seq_add(p2); 
    vector<Mat*> *dir_seq = str2ptr<vector<Mat*>>(dir_seq_add);
    Mat *dir = dir_seq->at(start[2]);    

    double threshold = (double) A5;

    if(noisy_line(start, end, mag, dir, threshold)){
        return TRUE;
    }else{
        return FALSE;
    }   
}


/* noisy_line_image(+START, +END, +MAG, +DIR, +THRESHOLD)
 */
PREDICATE(noisy_line_image, 5){
    vector<int> start = list2vec<int>(A1, 3);
    vector<int> end = list2vec<int>(A2, 3);
    
    char *p1 = (char*) A3;
    const string mag_add(p1); 
    Mat *mag = str2ptr<Mat>(mag_add);

    char *p2 = (char*) A4;
    const string dir_add(p2); 
    Mat *dir = str2ptr<Mat>(dir_add);
    
    double threshold = (double) A5;
    
    if(noisy_line(start, end, mag, dir, threshold)){
        return TRUE;
    }else{
        return FALSE;
    }   
}

/* similar_grad(+POINT1, +POINT2, +MAG, +DIR, +THRESHOLD)
 */
PREDICATE(similar_grad, 5){
    vector<int> point1 = list2vec<int>(A1, 3);
    vector<int> point2 = list2vec<int>(A2, 3);
    
    char *p1 = (char*) A3;
    const string mag_add(p1); 
    Mat *mag = str2ptr<Mat>(mag_add);

    char *p2 = (char*) A4;
    const string dir_add(p2); 
    Mat *dir = str2ptr<Mat>(dir_add);
    
    double threshold = (double) A5;

    vector<double> p1_mag_dir = get_mag_dir(point1, mag, dir);
    vector<double> p2_mag_dir = get_mag_dir(point2, mag, dir);
    
    if(similar_grad(p1_mag_dir, p2_mag_dir, threshold)){
        return TRUE;
    }else{
        return FALSE;
    }   
}

/* find_rectangle(+SRC, +POINTS, -RECTANGLE)
 */
PREDICATE(find_rectangle, 3){
    char *p1 = (char*) A1;
    const string add_img(p1);
    Mat *src = str2ptr<Mat>(add_img);

    vector<Scalar> pts = point_list2vec(A2);

    vector<Point> cv_pts;

    for(unsigned int i = 0; i < pts.size(); i++){
        Scalar s = pts.at(i);
        Point pt(s[0],s[1]);
        
        cv_pts.push_back(pt);
    }
    
//    cout << "Pts processed" << endl;
    
    RotatedRect rect = minAreaRect(cv_pts);
    
//    cout << "Rec fitted" << endl;
    
    Point2f rect_points[4]; 
    rect.points( rect_points );

    Mat drawing = src->clone();
    RNG rng(12345);
    Scalar color = Scalar( rng.uniform(0, 255), rng.uniform(0,255), rng.uniform(0,255) );

    for(int i = 0; i < 4; i++ ){
          line( drawing, rect_points[i], rect_points[(i+1)%4], color, 1, 8 );
    }
    
    for(unsigned int i = 0; i < pts.size(); i++){      
        circle(drawing, cv_pts[i],1,CV_RGB(255,0,0),3);
    }
    

//    cout << "Drawing processed" << endl;

    /// Show in a window
    namedWindow( "Contours", WINDOW_NORMAL );
    imshow( "Contours", drawing );

    return TRUE;
}



/* k_means_clusters(+SRC, +POINTS, -CLUSTERS)
 */
PREDICATE(k_means_clusters, 3){
    char *p1 = (char*) A1;
    const string add_img(p1);
    Mat *src = str2ptr<Mat>(add_img);

    vector<Scalar> pts = point_list2vec(A2);
    int sampleCount = (int) pts.size();
    int clusterCount = 3;

    vector<Point2f> points;
    Mat labels;    
    Mat centers;   


    for(int i = 0; i < sampleCount; i++){
        Scalar s = pts.at(i);
        Point2f pt((float)s[0],(float)s[1]);
        points.push_back(pt);
    }
        
//    cout << "Pts processed" << endl;
    
    int attempts = 10;
    int trials = 1000;
    double epsilon = 1/(double)trials;
    
    TermCriteria criteria(TermCriteria::COUNT + TermCriteria::EPS, trials, epsilon);
//    cout << "Criteria processed" << endl;
    
    kmeans(points, clusterCount, labels, criteria, attempts, KMEANS_PP_CENTERS, centers);
    
//    cout << "K-Means fitted" << endl;
    
    Mat drawing = src->clone();

    
//    
//    for(unsigned int i = 0; i < centers.size(); i++){      
//        circle(drawing, centers[i],1,CV_RGB(0,255,0),3);
//    }
     Scalar colorTab[] =
    {
        Scalar(0, 0, 255),
        Scalar(0,255,0),
        Scalar(255,100,100),
        Scalar(255,0,255),
        Scalar(0,255,255)
    };
    
    for(int i = 0; i < sampleCount; i++){    
        int clusterIdx = labels.at<int>(i);
        circle(drawing, points.at(i),1,colorTab[clusterIdx],3);
    }
    
//    cout << "Points drawn" << endl;
//    
    
//    for(int i = 0; i < sampleCount; i++ ){
//        int clusterIdx = labels.at<int>(i);
//        Point ipt = points.at<Point2f>(i);
//        circle( drawing, ipt, 2, colorTab[clusterIdx], FILLED, LINE_AA );
//    }
    

//    cout << "Drawing processed" << endl;

    /// Show in a window
    namedWindow( "Contours", WINDOW_NORMAL );
    imshow( "Contours", drawing );
    waitKey(0);
    destroyWindow("Contours");

    return TRUE;
}


/* single_link_clusters(+SRC, +POINTS, +NCLUSTERS, -CLUSTERS)
 */
PREDICATE(single_link_clusters, 4){
    char *p1 = (char*) A1;
    const string add_img(p1);
    Mat *src = str2ptr<Mat>(add_img);

    vector<Scalar> pts = point_list2vec(A2);
    int sampleCount = (int) pts.size();
    
    int clusterCount = (int) A3;

    vector<Point2f> points;
    for(int i = 0; i < sampleCount; i++){
        Scalar s = pts.at(i);
        Point2f pt((float)s[0],(float)s[1]);
        points.push_back(pt);
    }
        
//    cout << "Pts processed" << endl;
    
    vector<int> clusters = single_link_cluster(points, clusterCount);

//    cout << "Single Link fitted" << endl;
    
    Mat drawing = src->clone();
    Scalar colorTab[] = {
        Scalar(0, 0, 255),
        Scalar(0,255,0),
        Scalar(255,100,100),
        Scalar(255,0,255),
        Scalar(0,255,255)
    };
    
    for(int i = 0; i < sampleCount; i++){    
        circle(drawing, points[i],1,colorTab[clusters[i]],1);
    }
    
//    cout << "Points drawn" << endl;

    /// Show in a window
    namedWindow( "S-LINK", WINDOW_NORMAL );
    imshow( "S-LINK", drawing );
    waitKey(0);
    destroyWindow("S-LINK");
        
    return TRUE;    
}


/* find_rectangles_from_src(+IMG_SEQ, +FRAME, +POINTS, +MAX_CLUSTERS, -RECTANGLE)
 */
PREDICATE(find_rectangles_from_src, 5){
    char *p1 = (char*) A1;
    const string img_seq_add(p1); 
    vector<Mat*> *img_seq = str2ptr<vector<Mat*>>(img_seq_add);
    
    int frame = (int)A2;
    int max_clusters = (int)A4;
    
    vector<Scalar> pts = point_list2vec(A3);
    vector<Point2f> points;
    
    int sample_size = pts.size();
    cout << "Number of points: " << sample_size << ". " << flush;

    for(int i = 0; i < sample_size; i++){
        Scalar s = pts.at(i);
        Point2f pt(s[0],s[1]);
        
        points.push_back(pt);
    }
    
    vector<RotatedRect> best_rects;    
    vector<vector<Point2f>> best_clustered_points;
    
    cout << "Fitting rectangles..." << flush;
    
    best_fit_rectangle(points, max_clusters, best_rects, best_clustered_points);
    
    cout << " done, number of rectangles found: " << best_rects.size() << endl;

    Mat drawing = img_seq->at(frame)->clone();
    Scalar colorTab[] = {
        Scalar(0, 0, 255),
        Scalar(0,255,0),
        Scalar(255,100,100),
        Scalar(255,0,255),
        Scalar(0,255,255)
    };
    
    //Plot rectangles
    for(int i = 0; i < ((int)best_rects.size()); i++){
        RotatedRect rect = best_rects[i];
        Point2f rect_points[4]; 
        rect.points( rect_points );
        
        for(int j = 0; j < 4; j++ ){
              line(drawing, rect_points[j], rect_points[(j + 1) % 4], colorTab[i], 1, 8);
        }
        
        for(int j = 0; j < ((int)best_clustered_points[i].size()); j++){    
            circle(drawing, best_clustered_points[i][j], 1, colorTab[i], 1);
        }
    }
    
    /// Show in a window
    namedWindow( "S-LINK", WINDOW_NORMAL );
    imshow( "S-LINK", drawing );
    waitKey(0);
    destroyWindow("S-LINK");

    return A5 = rectvec2list(best_rects); 
}



/* find_rectangles(+POINTS, +MAX_CLUSTERS, -RECTANGLE)
 */
PREDICATE(find_rectangles, 3){
    vector<Scalar> pts = point_list2vec(A1);
    vector<Point2f> points;
    
    int max_clusters = (int)A2;
    
    int sample_size = pts.size();
    cout << "Number of points: " << sample_size << ". " << flush;

    for(int i = 0; i < sample_size; i++){
        Scalar s = pts.at(i);
        Point2f pt(s[0],s[1]);
        
        points.push_back(pt);
    }
    
    vector<RotatedRect> best_rects;    
    vector<vector<Point2f>> best_clustered_points;
    
    cout << "Fitting rectangles..." << flush;
    
    best_fit_rectangle(points, max_clusters, best_rects, best_clustered_points);
    
    cout << " done, number of rectangles found: " << best_rects.size() << endl;
        
    return A3 = rectvec2list(best_rects); 
}


