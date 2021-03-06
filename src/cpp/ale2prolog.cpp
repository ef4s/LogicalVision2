/* ALE interface library for prolog
 * ============================
 * Version: 0.1
 * Author: Peter Efstathiou <peter.efstathiou@gmail.com>
 */
 
#include <iostream>
#include <ale_interface.hpp>
#include "../../../../LogicalVision/Arcade-Learning-Environment-0.5.1/src/ale_interface.hpp"
#ifdef __USE_SDL
    #include <SDL.h>
#endif

using namespace std;



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
