#include "draw.hpp"
#include "sampler.hpp"
#include "utils.hpp"
#include "memread.hpp"
#include "errors.hpp"

#include <opencv2/core/core.hpp>
#include "opencv2/imgproc/imgproc.hpp"
#include <opencv2/highgui/highgui.hpp>

#include <iostream>

#include <algorithm> 
#include <functional>
#include <string>
#include <tgmath.h>
#include <math.h>

using namespace std;
using namespace cv;

template <class Type>
vector<Type> vec_subtract(const vector<Type> a, const vector<Type> b) {
    assert(a.size() == b.size());
    vector<Type> diff(a.size());
    for(unsigned int i = 0; i < a.size(); i++){
        diff[i] = a[i] - b[i];    
    }
    return diff;
}

vector<double>get_mag_dir(const vector<int>loc, const vector<Mat> *mag_seq, const vector<Mat> *dir_seq){
    vector<double> mag_dir;
    Mat m = mag_seq->at(loc[2]);
    mag_dir[0] = m.at<double>(loc[1],loc[0]);
    
    m = dir_seq->at(loc[2]);    
    mag_dir[1] = m.at<double>(loc[1],loc[0]);

    return mag_dir;
}

vector<double>get_mag_dir(const vector<int>loc, const Mat *mag, const Mat *dir){
    vector<double> mag_dir(2);
//    cout << loc[0] << '\t' << loc[1] << endl;
    mag_dir[0] = mag->at<double>(loc[1],loc[0]);
    mag_dir[1] = dir->at<double>(loc[1],loc[0]);
    return mag_dir;
}

vector<double>sample_point(const vector<int>loc, const Mat mag, const Mat dir) {
    vector<double> mag_dir(2);  

    mag_dir[0] = mag.at<double>(loc[1],loc[0]);
    mag_dir[1] = dir.at<double>(loc[1],loc[0]);

	return mag_dir;
}

double angle_diff(const double a1, const double a2){    
    double C1 = pow(sin(a1) - sin(a2), 2);
    double C2 = pow(cos(a1) - cos(a2), 2);
    return acos((2.0 - C1 - C2)/2.0);
}

bool similar_grad(const vector<double> d1, const vector<double> d2, const double threshold){
    bool b = (abs(d2[0]) >= threshold);
    
//    cout << "\t\t" << d1[0] << ","<< d1[1] <<  ": " << d2[0] << ", "<< d2[1] << endl;
    
//    double ANGLE_THRESHOLD = 3.1415 / 2.0;
//    bool c = (angle_diff(d1[1], d2[1]) <= ANGLE_THRESHOLD);
    bool c = true;
        
    return b && c;
}

double vec_len(const vector<int> v){
    double l = 0;
    
    for(unsigned int i = 0; i < v.size(); i++){
        l += pow(v[i],2);
    }
    
    return sqrt(l);
}

bool noisy_line(const vector<int> start, const vector<int> end, const Mat *mag, const Mat *dir){
    
//    cout << start[0] << ","<< start[1] << ", "<< start[2] << ": " << end[0] << ", "<< end[1] << ", "<< end[2] << endl;
    vector<int> diff = vec_subtract(end, start);
    double len = vec_len(diff);
    vector<double> norm_diff(3);
//     cout << "Diff and norm diff are: " << endl;
    for(int i = 0; i < 3; i++){
        norm_diff[i] = diff[i] / (double) len;
//        cout << diff[i] << " vs \t" << norm_diff[i] << endl;
    }   
    
    
    vector<double> start_mag_dir = get_mag_dir(start, mag, dir);
    
    if(len <= 2) {
//        cout << "Len too small" << endl;
        return false;
    }
            
//    double EPSILON = 0.1;
    const double THRESHOLD = 0.9;
    const double NOISE_ESTIMATE = 0.4;
    int K = (THRESHOLD / NOISE_ESTIMATE);  
    
    random_device rd;
    mt19937 gen(rd());
    uniform_real_distribution<> dis(0, len);
//    cout << "Len is : " << len << ", K is " << K << endl;
    for(int i = 0; i < K; i++){
        double r = dis(gen);
        vector<int> loc = start;

        for(int i = 0; i < 3; i++){
//            loc[i] += r * sqrt(pow(diff[i],2) / pow(len,2));
            
            loc[i] += r * norm_diff[i] ;
        }      
        
//        cout << "\t r = " << r << ", new sample: " << loc[0] << "," << loc[1] << "," << loc[2];
        
        vector<double> t_mag_dir = get_mag_dir(loc, mag, dir);
        
//        cout << "new sample @" << loc[0] << "," << loc[1] << "," << loc[2] << ", vals:" << t_mag_dir[0] << "," << t_mag_dir[1] << " vs "  << start_mag_dir[0] << "," << start_mag_dir[1] << endl;
        if(!similar_grad(start_mag_dir, t_mag_dir, THRESHOLD)){
//            cout << "FAILED!" << endl;
            return false;
        }
    }
//    cout << "SUCEEDED!" << endl;
    return true;
}


void gradient_image(Mat *src, Mat *mag, Mat *dir){
    int scale = 1;
    int delta = 0;
    int ddepth = CV_64F;
 
    Mat sobel_x, sobel_y, src_adj;

//    GaussianBlur(*src, src_adj, Size(5,5), 0, 0, BORDER_DEFAULT);
    cvtColor(*src, src_adj, CV_BGR2GRAY);    /// Convert it to gray
    
    Sobel(src_adj, sobel_x, ddepth, 1, 0, 3, scale, delta, BORDER_DEFAULT);
    Sobel(src_adj, sobel_y, ddepth, 0, 1, 3, scale, delta, BORDER_DEFAULT);

    addWeighted(sobel_x, 0.5, sobel_y, 0.5, 0, *mag);
    phase(sobel_x, sobel_y, *dir);
}

void blur_image(Mat *src, int step_size, Mat *blurred){
    GaussianBlur(*src, *blurred, Size(step_size,step_size), 0, 0, BORDER_DEFAULT);
}
