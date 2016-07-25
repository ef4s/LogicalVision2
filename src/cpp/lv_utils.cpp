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
vector<Type> vec_subtract(vector<Type> a, vector<Type> b) {
    assert(a.size() == b.size());
//    cout << "HERE A Size = " << a.size() << ", B=" << b.size() << endl;
    vector<Type> diff(a.size());
    for(unsigned int i = 0; i < a.size(); i++){
//        cout << "HERE A Val = " << a[i] << ", B=" << b[i] << endl;
        diff[i] = a[i] - b[i];    
    }
    return diff;
}

vector<double>get_dir_mag(vector<Mat> *dir_seq, vector<Mat> *mag_seq, vector<int>loc){
    vector<double> dir_mag;
    Mat m = dir_seq->at(loc[2]);    
    dir_mag[0] = m.at<double>(loc[1],loc[0]);
    m = mag_seq->at(loc[2]);
    dir_mag[1] = m.at<double>(loc[1],loc[0]);
    return dir_mag;
}

vector<double>get_dir_mag(Mat *dir, Mat *mag, vector<int>loc){
    vector<double> dir_mag(2);
    dir_mag[0] = dir->at<double>(loc[1],loc[0]);
    dir_mag[1] = mag->at<double>(loc[1],loc[0]);
    return dir_mag;
}

double vec_len(vector<int> v){
    double l = 0;
    
    for(unsigned int i = 0; i < v.size(); i++){
        l += pow(v[i],2);
    }
    
    return sqrt(l);
}

bool noisy_line(vector<int> start, vector<int> end, Mat *mag, Mat *dir){
    
    vector<int> diff = vec_subtract(start, end);
   
    vector<double> start_dir_mag = get_dir_mag(dir, mag, start);

    int len = (int)vec_len(diff);
            
    double EPSILON = 0.1;
    double THRESHOLD = 0.9;
    double NOISE_ESTIMATE = 0.2;
    int K = max((EPSILON / NOISE_ESTIMATE),1.0);  
    
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
        
        vector<double> t_dir_mag = get_dir_mag(dir, mag, loc);
        
//        cout << "new sample @" << loc[0] << "," << loc[1] << "," << loc[2] << ", vals:" << t_dir_mag[0] << "," << t_dir_mag[1] << ","  << start_dir_mag[0] << "," << start_dir_mag[1] << endl;
        if(!(abs(start_dir_mag[0] - t_dir_mag[0]) < THRESHOLD 
                && (abs(t_dir_mag[1]) > THRESHOLD))){
            return false;
        }
    }
    
    return true;
}

vector<double>sample_point(Mat mag, Mat dir, vector<int>loc) {
    vector<double> mag_dir(2);  

    mag_dir[0] = dir.at<double>(loc[1],loc[0]);
    mag_dir[1] = mag.at<double>(loc[1],loc[0]);

	return mag_dir;
}


