#include "draw.hpp"
#include "sampler.hpp"
#include "utils.hpp"
#include "memread.hpp"
#include "errors.hpp"

#include <opencv2/core/core.hpp>
#include "opencv2/imgproc/imgproc.hpp"
#include <opencv2/highgui/highgui.hpp>
#include "opencv2/shape/shape_distance.hpp"

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

bool noisy_line(const vector<int> start, const vector<int> end, const Mat *mag, const Mat *dir, double grad_threshold){
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
        if(!similar_grad(start_mag_dir, t_mag_dir, grad_threshold)){
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

double sq_euclidian_distance(const Point &p1, const Point &p2){
    return pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2);    
}

double euclidian_distance(const Point &p1, const Point &p2){
    return norm(p1 - p2);
//    return sqrt(sq_euclidian_distance(p1, p2));
}

vector<Point2f> links_to_points(const vector<Point2f> &points, const vector<int> &links){
    vector<Point2f> p;
    for(int l : links){
        p.push_back(points[l]);
    }
 
    return p;
}

Point2f mean_links(const vector<Point2f> &points, const vector<int> &links){
    
    vector<Point2f> pts = links_to_points(points, links);
    vector<Point2f> m1;

    reduce(pts, m1, 1, CV_REDUCE_AVG);

    return m1[0];
}


vector<vector<double>> calc_distances(const vector<Point2f> &points, const vector<vector<int>> &links){
    vector<vector<double>> distances;
    for(int i = 1; i < ((int)links.size()); i++){
        vector<Point2f> hi;
        convexHull(links_to_points(points, links[i]), hi);
        
        for(int j = 0; j < i; j++){
            //fit convex hull
//            double min = abs(pointPolygonTest(hi, points[links[j][0]], true));
            double min = -pointPolygonTest(hi, points[links[j][0]], true);
            for(int k = 1; k < ((int)links[j].size()); k++){
                double dist = -pointPolygonTest(hi, points[links[j][k]], true);
                if(dist < min){
                    min = dist;
                }
            }
            
            vector<double> t = {min, (double)i, (double)j};
        
            distances.push_back(t);
        }
    }
    
    sort(distances.begin(), distances.end(), [](const vector<double>& a, const vector<double>& b) {return a[0] < b[0];});
    
    return distances;  
}

vector<int> single_link_cluster(const vector<Point2f> &points, const int n_clusters){
    double min_distance = 10;
    int n_points = points.size();
    
    vector<vector<int>> links;
    for(int i = 0; i < n_points; i++){
        //each element is linked to itself
        vector<int> l = {i};
        links.push_back(l);
    }

    if(n_points == 1){
        return links[0];
    }
    
        
    vector<vector<double>> distances = calc_distances(points,links);
    double dist = distances[0][0];
    
    while( min_distance > dist || 
        ((int)links.size()) > n_clusters){
        //calc distances
        vector<int> pts;
                
        for(int i = 0; i < ((int)distances.size()); i++){
            if(distances[i][0] <= dist || 
                distances[i][0] <= min_distance){
                
                int p1 = distances[i][1];
                int p2 = distances[i][2];
                
                // If the points have not already been linked
                if(find(pts.begin(), pts.end(), p1) == pts.end() &&
                   find(pts.begin(), pts.end(), p2) == pts.end()){
                   
                    //find lowest element pair
                    pts.push_back(p1);
                    pts.push_back(p2);
                    
                    //add the link to the list of links
                    vector<int> p1_links = links[p1];
                    vector<int> p2_links = links[p2];
                            
                    vector<int> merged_links;
                    merged_links.reserve(p1_links.size() + p2_links.size()); 
                    merged_links.insert(merged_links.end(), p1_links.begin(), p1_links.end() );
                    merged_links.insert(merged_links.end(), p2_links.begin(), p2_links.end() );
                    
                    links.push_back(merged_links);
                }
                
            }
        }
        // Remove the points that we've just processed
        sort(pts.begin(), pts.end(), greater<int>());
        for(int p : pts){
            links.erase(links.begin() + p);
        }
        
        distances = calc_distances(points,links);
        
        if(links.size() <= 1){
            dist = min_distance;
        }else{
            dist = distances[0][0];
        }
    }
    
    vector<int> clusters;
    clusters.resize(n_points);
    
    for(int cluster = 0; cluster < ((int)links.size()); cluster++){
        for(int p : links[cluster]){
            clusters[p] = cluster;                    
        }
    }
    
    return clusters;
}

double score_fit(const vector<Point2f> &points, const RotatedRect &rect){
    Point2f t_rect_points[4]; 
    rect.points(t_rect_points);
    vector<Point2f> rect_points(begin(t_rect_points), end(t_rect_points));

    double score = 0;

    for(Point2f point : points){
        score += pow(pointPolygonTest(rect_points, point, true), 2);
    }
    
    return score;//sqrt(score / (double)points.size());
}

double score_fit(const vector<vector<Point2f>> &clustered_points, const vector<RotatedRect> &rects){
    double n_rects = rects.size();
    double score = 0;
    double dist = 1;
        
    for(int i = 0; i < n_rects; i++){
        score += score_fit(clustered_points[i], rects[i]);
    }
    
    if(n_rects != 1){
        for(int i = 0; i < n_rects; i++){
            Point2f r_points[4]; 
            rects[i].points(r_points);
            vector<Point2f> rect_points(begin(r_points), end(r_points));
            double min_dist = numeric_limits<double>::max();
            for(int j = 0; j < n_rects; j++){
                if(i != j){
                    Point2f s_points[4]; 
                    rects[j].points(s_points);
                    for(int k = 0; k < 4; k++){
                        double d = abs(pointPolygonTest(rect_points, s_points[k], true));
                        if(d < min_dist){
                            min_dist = d;
                        }
                    }
                }
            }
            dist += min_dist;
        }
    }
    
    dist /= n_rects;
    
    return score / dist;
}

RotatedRect shift_edge(const RotatedRect &r, const int e, const int inv_epsilon){
    Point2f t_rect_points[4]; 
    r.points(t_rect_points);

    Point2f diff = t_rect_points[e] - t_rect_points[(e + 1) % 4];

    double C = sqrt(pow(diff.x,2) + pow(diff.y,2)) * inv_epsilon;
    
    if(C != 0){
        diff.x /= C;
        diff.y /= C;
    }
    
    t_rect_points[e].x += diff.y;
    t_rect_points[e].y -= diff.x;
    
    t_rect_points[(e + 1) % 4].x += diff.y;
    t_rect_points[(e + 1) % 4].y -= diff.x;

    vector<Point2f> p(begin(t_rect_points), end(t_rect_points));
    
    RotatedRect rect = minAreaRect(p);
    
    return rect;
}

RotatedRect optimise_side(const RotatedRect &r, const vector<Point2f> &points, const int side){
    RotatedRect new_r(r.center,r.size, r.angle);
    RotatedRect old_r = new_r;
    double old_score = score_fit(points, new_r);
    double new_score = old_score; 
    
    const int inv_epsilon = 10;
    
    if(old_score > 1 /  ((double) inv_epsilon)){
        while(new_score <= old_score){
            old_r = new_r;
            old_score = new_score;
            
            new_r = shift_edge(new_r, side, inv_epsilon);
            new_score = score_fit(points, new_r);
//            cout << "\t\t" << "For side " << side << ", new score = " << new_score << endl;
        }
    }
    
    return old_r;
}

void improve_fit_rectangles(const vector<vector<Point2f>> &clustered_points, vector<RotatedRect> &rects){
    for(int cluster = 0; cluster < ((int)rects.size()); cluster++){
        //Optimise left
        rects[cluster] = optimise_side(rects[cluster], clustered_points[cluster], 0);
        
        //Optimise top  
        rects[cluster] = optimise_side(rects[cluster], clustered_points[cluster], 1);
         
        //Optimise right
        rects[cluster] = optimise_side(rects[cluster], clustered_points[cluster], 2);
        
        //Optimise bottom      
        rects[cluster] = optimise_side(rects[cluster], clustered_points[cluster], 3);
    }
}

void best_fit_rectangle(const vector<Point2f> &points, vector<RotatedRect> &best_rects, vector<vector<Point2f>> &best_clustered_points){
    
    int n_points = (int)points.size();
    
    if(n_points == 0){return;}

    double best_fit = numeric_limits<double>::max();
    
//    cout << "\tFinding rectangles..." << endl;
    //Lets look for no more than 5 objects
    for(int n_clusters = 1; n_clusters <= 5; n_clusters++){
    
//        cout << "\tClustering..." << flush;
        //Classify Points
        vector<int> cluster_idx = single_link_cluster(points, n_clusters);
//        cout << " done" << endl;
        
        //Sort points
//        cout << "\tSorting points..." << flush;
        vector<vector<Point2f>> c_points;
        c_points.resize(n_clusters);        
        for(int i = 0; i < n_points; i++){
            c_points[cluster_idx[i]].push_back(points[i]);
        }
//        cout << " done" << endl;


        //Fit rectangles
//        cout << "\tFitting Rectangles..." << flush;
        vector<RotatedRect> rects;
        rects.resize(n_clusters);
        for(int cluster = 0; cluster < n_clusters; cluster++){
            if(c_points[cluster].size() != 0){
                rects[cluster] = minAreaRect(c_points[cluster]);
            }
        }
//        cout << " done" << endl;
        
        //Score fit
        double score = score_fit(c_points, rects);
        
        if(score < best_fit && score != 0){
            best_rects.assign(rects.begin(),rects.end());
            
            best_clustered_points.clear();
            best_clustered_points.resize(((int)cluster_idx.size()));
            for(int i = 0; i < ((int)points.size()); i++){
                best_clustered_points[cluster_idx[i]].push_back(points[i]);
            }
            best_fit = score;            
        }
    }
//    cout << "done" << endl;
    
//    cout << "\tImproving fit..." << flush;
    improve_fit_rectangles(best_clustered_points, best_rects);
//    cout << "done" << endl;
}



