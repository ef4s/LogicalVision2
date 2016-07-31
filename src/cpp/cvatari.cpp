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

/* gradient_seq(+IMGSEQ, -Magnitude, -Direction)
 * get gradient of an image sequence IMGSEQ
 */
PREDICATE(gradient_seq, 3) {
    char *p1 = (char*) A1;
    const string add_seq(p1);
    vector<Mat> *seq = str2ptr<vector<Mat>>(add_seq);
    vector<Mat*> *mag_seq = new vector<Mat*>;
    vector<Mat*> *dir_seq = new vector<Mat*>;

    for(vector<Mat>::iterator src = seq->begin(); src != seq->end(); src++){    
        Mat *mag, *dir;
        
        gradient_image(&(*src), mag, dir);
//        cout << "BACK HERE" << endl;
//        
        cout << "Mag address: " << ptr2str(mag) << endl;
        cout << "Dir address: " << ptr2str(dir) << endl;
        
        cout << "SEQ: " << src->rows << ", " << src->cols << endl;
        cout << "MAG: " << mag->rows << ", " << mag->cols << endl; 
        cout << "DIR: " << dir->rows << ", " << dir->cols << endl;
        for(int i=0; i<mag->rows; i++){
            for(int j=0; j<mag->cols; j++){
                double pix = mag->at<double>(i,j);
//                if(pix != 0){
                    cout << i << ", " << j << ": " << pix << endl;
//                }
            }
        }


//        cout << "Pix:" << mag->at<double>(0,0) << flush;  
//        cout << "~HERE~" << flush;      
//        cout << ", " << flush << dir->at<double>(0,0) << endl;
        
        mag_seq->push_back(mag);
        dir_seq->push_back(dir);
        
    }

    string add_mag = ptr2str(mag_seq);
    A2 = PlTerm(add_mag.c_str());
    cout << "Mag address: " << add_mag << endl;

    string add_dir = ptr2str(dir_seq);
    A3 = PlTerm(add_dir.c_str());
    cout << "Dir address: " << add_dir << endl;

    return TRUE;
}

/* gradient_image(+IMGADD, -Magnitude, -Direction)
 * get gradient of local area of point [X, Y, Z] in image sequence IMGSEQ
 */
PREDICATE(gradient_image, 3) {
    char *p1 = (char*) A1;
    const string add_img(p1);
    Mat *src = str2ptr<Mat>(add_img);
    
    Mat *mag, *dir;
    
    gradient_image(src, mag, dir);
        
    cout << "BACK HERE" << endl;
    string add_mag = ptr2str(mag);
    A2 = PlTerm(add_mag.c_str());
    cout << "Mag address: " << add_mag << endl;

    string add_dir = ptr2str(dir);
    A3 = PlTerm(add_dir.c_str());
    cout << "Dir address: " << add_dir << endl;

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
    vector<int> loc = list2vec<int>(A1, 3);

    char *p1 = (char*) A2;
    const string mag_seq_add(p1); 
    vector<Mat> *mag_seq = str2ptr<vector<Mat>>(mag_seq_add);
    Mat mag = mag_seq->at(loc[2]);    
        
    char *p2 = (char*) A3;
    const string dir_seq_add(p2); 
    vector<Mat> *dir_seq = str2ptr<vector<Mat>>(dir_seq_add);
    Mat dir = dir_seq->at(loc[2]);    
    
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
    const string mag_seq_add(p1); 
    Mat mag = *str2ptr<Mat>(mag_seq_add);
    
    char *p2 = (char*) A3;
    const string dir_seq_add(p2); 
    Mat dir = *str2ptr<Mat>(dir_seq_add);

	return A4 = vec2list(sample_point(loc,mag,dir));
}


/* noisy_line(+START, +END, +IMGSEQ, +DIRSEQ)
 * Samples points and checks if they're correct with a set probabilty   
 * @POINTS = [[X, Y]]: a list of points of interest
 * @RECTANGLE = the rectangle that closes the set of points
 */
PREDICATE(noisy_line, 4){
    vector<int> start = list2vec<int>(A1, 3);
    vector<int> end = list2vec<int>(A2, 3);
    
    if(start[2] != end[2]) {
        return FALSE;
    }
    
    char *p1 = (char*) A3;
    const string mag_seq_add(p1); 
    vector<Mat> *mag_seq = str2ptr<vector<Mat>>(mag_seq_add);
    Mat *mag = &(mag_seq->at(start[2]));    
        
    char *p2 = (char*) A3;
    const string dir_seq_add(p2); 
    vector<Mat> *dir_seq = str2ptr<vector<Mat>>(dir_seq_add);
    Mat *dir = &(dir_seq->at(start[2]));    

    if(noisy_line(start, end, mag, dir)){
        return TRUE;
    }else{
        return FALSE;
    }   
}


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



///* noisy_extend_line(+START, +END, +IMGSEQ, +DIRSEQ, +MAX_SIZE, -NEW_START, -NEW_END)
// * Samples points and checks if they're correct with a set probabilty
// * @POINTS = [[X, Y]]: a list of points of interest
// * @RECTANGLE = the rectangle that closes the set of points
// */
//PREDICATE(noisy_extend_line, 7){
//    vector<int> start = list2vec<int>(A1, 3);
//    vector<int> end = list2vec<int>(A2, 3);
//    vector<int> diff = vec_subtract(start, end);
//    int len = sqrt(diff[0] + diff[1] + diff[2]);

//    char *p1 = (char*) A3;
//    const string mag_seq_add(p1); 
//    vector<Mat> *mag_seq = str2ptr<vector<Mat>>(mag_seq_add);

//    char *p2 = (char*) A4;
//    const string dir_seq_add(p2); 
//    vector<Mat> *dir_seq = str2ptr<vector<Mat>>(dir_seq_add);

//    vector<double> start_mag_dir = get_mag_dir(start, mag_seq, dir_seq);

//    //Sample n points along the target line
//    //from k subsets of size q, if the number of sucesses is above p then return true
//    double EPSILON = 0.1;
//    double THRESHOLD = 0.9;
//    double NOISE_ESTIMATE = 0.2;
//    int K = len * (EPSILON / NOISE_ESTIMATE);  
//    int q = K * (1 - NOISE_ESTIMATE);
//    int p = 0;
//    
//    //use a window, stop when it falls to below the target value
//    bool valid = true;
//    vector<int>new_start = list2vec<int>(A1, 3);
//    vector<bool>valid_counts(K);
//    
//    for(int k = 0; k < K; k++){
//        //cycle through one step at a time
//        for(int j = 0; j < 3; j++){
//            new_start[j] += (k - (K / 2)) * (diff[j] / len);
//        }
//        
//        vector<double> t_mag_dir = get_mag_dir(new_start, dir_seq, mag_seq);        
//                
//        if((start_mag_dir[0] == t_mag_dir[0]) && (t_mag_dir[1] > THRESHOLD)){
//            p++;
//            valid_counts[k] = true;
//            valid_counts[k] = false;
//        }
//    }
//    
//    int i = 1;
//    while(valid){
//        //cycle through one step at a time
//        for(int j = 0; j < 3; j++){
//            new_start[i] += i * (diff[j] / len);
//        }
//        
//        bool new_valid_point = false;
//        
//        vector<double> t_mag_dir = get_mag_dir(new_start, mag_seq, dir_seq);        
//        
//        if(similar_grad(start_mag_dir, t_mag_dir, THRESHOLD)){
//            p++;
//            new_valid_point = true;
//        }
//        if(!valid_counts[i % K] && new_valid_point){
//            p++;
//        }else{
//            p--;
//        }
//        
//        valid_counts[i % K] = new_valid_point;
//        
//        valid = p > q;
//    }
//    
//    // The terminal new_end value is the best edge estimate
//    valid = true;
//    vector<int>new_end = list2vec<int>(A2, 3);
//    
//    for(int k = 0; k < K; k++){
//        //cycle through one step at a time
//        for(int j = 0; j < 3; j++){
//            new_end[i] += (k - (K / 2)) * (-diff[j] / len);
//        }
//        
//        vector<double> t_mag_dir = get_mag_dir(new_end, mag_seq, dir_seq);        
//                
//        if(similar_grad(start_mag_dir, t_mag_dir, THRESHOLD)){
//            p++;
//            valid_counts[k] = true;
//        }else{
//            valid_counts[k] = false;
//        }
//    }

//    
//    while(valid){
//        //cycle through one step at a time
//        for(int j = 0; j < 3; j++){
//            new_end[i] += i * (diff[j] / len);
//        }
//        
//        vector<double> t_mag_dir = get_mag_dir(new_end, mag_seq, dir_seq);        
//        
//        bool new_valid_point = false;
//        if(similar_grad(start_mag_dir, t_mag_dir, THRESHOLD)){
//            p++;
//            new_valid_point = true;
//        }
//        if(!valid_counts[i % K] && new_valid_point){
//            p++;
//        }else{
//            p--;
//        }
//        
//        valid_counts[i % K] = new_valid_point;
//        
//        valid = p > q;
//    }
//    
//    vector<double> double_start(new_start.begin(), new_start.end());            
//    A6 = vec2list(double_start);
//    vector<double> double_end(new_end.begin(), new_end.end());
//    A7 = vec2list(double_end);
//    return TRUE;
//}

