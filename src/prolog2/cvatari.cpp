/* ALE interface library for prolog
 * ============================
 * Version: 0.1
 * Author: Peter Efstathiou <peter.efstathiou@gmail.com>
 */

#include "../img2/draw.hpp"
#include "../img2/sampler.hpp"
#include "../utils2/utils.hpp"
#include "../utils2/memread.hpp"

#include <opencv2/core/core.hpp>
#include "opencv2/imgproc/imgproc.hpp"
#include <opencv2/highgui/highgui.hpp>
#include <SWI-cpp.h>
#include <SWI-Prolog.h>

#include <iostream>
//#include <ale_interface.hpp>
#include "../../../../LogicalVision/Arcade-Learning-Environment-0.5.1/src/ale_interface.hpp"

#ifdef __USE_SDL
    #include <SDL.h>
#endif

#include <string>
#include <tgmath.h>
#include <math.h>

using namespace std;
using namespace cv;

/* load_ale(+Rom, -ALE)
 * Load Atari game ROM file into emulator ALE
 */
PREDICATE(load_ale, 2) {

    char *rom = (char *)A1;
    ALEInterface *ale = new ALEInterface();

    // Get & Set the desired settings
    ale->setInt("random_seed", 123);
    //The default is already 0.25, this is just an example
    ale->setFloat("repeat_action_probability", 0.25);

    #ifdef __USE_SDL
        ale->setBool("display_screen", true);
        ale->setBool("sound", true);
    #endif

    // Load the ROM file. (Also resets the system for new settings to
    // take effect.)
    ale->loadROM(rom);

    string add = ptr2str(ale); // address of ALE in stack
    term_t t2 = PL_new_term_ref();
    PL_put_atom_chars(t2, add.c_str());
    return A2 = PlTerm(t2); // return the pointer as a string
}


/*random_action(+ALE, -Reward)
 * Perform a random action and get the reward
 */
PREDICATE(random_action, 2){
    char *p1 = (char*) A1;
    string add = ptr2str(p1); // address of ALE in stack
    ALEInterface *ale = str2ptr<ALEInterface>(add);

    // Get the vector of legal actions
    ActionVect legal_actions = ale->getLegalActionSet();
    Action a = legal_actions[rand() % legal_actions.size()];

    double reward = ale->act(a);
    return A2 = PlTerm(reward);
}


/* action_noop(+ALE, -Reward)
 * Perform PLAYER_A_NOOP action and get the reward
 */
PREDICATE(action_noop, 2){
    char *p1 = (char*) A1;
    string add = ptr2str(p1); // address of ALE in stack
    ALEInterface *ale = str2ptr<ALEInterface>(add);

    Action a = PLAYER_A_NOOP;

    double reward = ale->act(a);
    return A2 = PlTerm(reward);
}

/* action_fire(+ALE, -Reward)
 * Perform PLAYER_A_FIRE action and get the reward
 */
PREDICATE(action_fire, 2){
    char *p1 = (char*) A1;
    string add = ptr2str(p1); // address of ALE in stack
    ALEInterface *ale = str2ptr<ALEInterface>(add);

    Action a = PLAYER_A_FIRE;

    double reward = ale->act(a);
    return A2 = PlTerm(reward);

}

/* action_left(+ALE, -Reward)
 * Perform PLAYER_A_LEFT action and get the reward
 */
PREDICATE(action_left, 2){
    char *p1 = (char*) A1;
    string add = ptr2str(p1); // address of ALE in stack
    ALEInterface *ale = str2ptr<ALEInterface>(add);

    Action a = PLAYER_A_LEFT;

    double reward = ale->act(a);
    return A2 = PlTerm(reward);
}

/* action_right(+ALE, -Reward)
 * Perform PLAYER_A_RIGHT action and get the reward
 */
PREDICATE(action_right, 2){
    char *p1 = (char*) A1;
    string add = ptr2str(p1); // address of ALE in stack
    ALEInterface *ale = str2ptr<ALEInterface>(add);

    Action a = PLAYER_A_RIGHT;

    double reward = ale->act(a);
    return A2 = PlTerm(reward);
}

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
/* gradient_image(+IMGSEQ, +IMG, -Magnitude, -Direction)
 * get gradient of local area of point [X, Y, Z] in image sequence IMGSEQ
 */
PREDICATE(gradient_image, 4) {
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
    cout << "Gradients Calculated" << endl;
    addWeighted(grad_x, 0.5, grad_y, 0.5, 0, *grad);
    cout << "Magnitudes Calculated" << endl;
    phase(grad_x, grad_y, *ang);
    cout << "Angles Calculated" << endl;

    string add_grad = ptr2str(grad);
    A3 = PlTerm(add_grad.c_str());
    string add_ang = ptr2str(ang);
    A4 = PlTerm(add_ang.c_str());
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
    for (it; it != seq->end(); ++it) {
        absdiff(first_img, *it, diff_img);
        newseq->push_back(diff_img.clone());
        first_img = *it;
    }
    string add = ptr2str(newseq);
    cout << add.c_str() << endl;
    return A2 = PlTerm(add.c_str());
}
