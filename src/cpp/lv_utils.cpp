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
    mag_dir[0] = mag->at<double>(loc[1],loc[0]);
    mag_dir[1] = dir->at<double>(loc[1],loc[0]);
    return mag_dir;
}

vector<double>sample_point(const vector<int>loc, const Mat mag, const Mat dir) {
    vector<double> mag_dir(2);  

    mag_dir[0] = dir.at<double>(loc[1],loc[0]);
    mag_dir[1] = mag.at<double>(loc[1],loc[0]);

	return mag_dir;
}

double angle_diff(const double a1, const double a2){    
    double C1 = pow(sin(a1) - sin(a2), 2);
    double C2 = pow(cos(a1) - cos(a2), 2);
    return acos((2.0 - C1 - C2)/2.0);
}

bool similar_grad(const vector<double> d1, const vector<double> d2, const double threshold){
//   bool b = (abs(d1[0] - d2[0]) >= threshold);
//    cout << "C++Mag: " << abs(d1[0] - d2[0]) << ": " << d1[0] <<", " << d2[0];
    bool b = (abs(d2[0]) >= threshold);
    cout << "C++Mag: " << abs(d2[0]) << ": " << d1[0] <<", " << d2[0];
    bool c = (angle_diff(d1[1], d2[1]) <= (3.1415 / 4.0));
    cout << ", Dir: " << angle_diff(d1[1], d2[1]) << ": " << d1[1] <<", " <<  d2[1] << endl;
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
    
    cout << start[0] << ", "<< start[1] << ", "<< start[2] << ": " << end[0] << ", "<< end[1] << ", "<< end[2] << endl;
    
    vector<int> diff = vec_subtract(start, end);
   
    vector<double> start_mag_dir = get_mag_dir(start, mag, dir);

    int len = (int)vec_len(diff);
    
    if(len <= 2) return false;
            
    double EPSILON = 0.1;
    double THRESHOLD = 0.9;
    double NOISE_ESTIMATE = 0.2;
    int K = max(len * (EPSILON / NOISE_ESTIMATE),1.0);  
    
    random_device rd;
    mt19937 gen(rd());
    uniform_int_distribution<> dis(0, len);
    for(int i = 0; i < K; i++){
        int r = dis(gen);
        vector<int> loc = start;
        for(int i = 0; i < 3; i++){
            loc[i] += r * sqrt(pow(diff[i],2) / pow(len,2));
        }      
        
//        cout << "r = " << r << ", new sample: " << loc[0] << "," << loc[1] << "," << loc[2] << endl;
        
        vector<double> t_mag_dir = get_mag_dir(loc, mag, dir);
        
//        cout << "new sample @" << loc[0] << "," << loc[1] << "," << loc[2] << ", vals:" << t_mag_dir[0] << "," << t_mag_dir[1] << ","  << start_mag_dir[0] << "," << start_mag_dir[1] << endl;
        if(!similar_grad(start_mag_dir, t_mag_dir, THRESHOLD)){
            return false;
        }
    }
    
    return true;
}



