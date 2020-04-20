// helper quicksort implementation
void swap(int* a, int* b){ 
    int t = *a; 
    *a = *b; 
    *b = t; 
}

int partition (int arr[], int low, int high){ 
    int pivot = arr[high];
    int i = (low - 1);
    for (int j = low; j <= high- 1; j++){ 
        if (arr[j] < pivot) { 
            i++;
            swap(&arr[i], &arr[j]); 
        } 
    } 
    swap(&arr[i + 1], &arr[high]); 
    return (i + 1); 
} 

void quickSort(int arr[], int low, int high) { 
    if (low < high){ 
        int pi = partition(arr, low, high); 
        quickSort(arr, low, pi - 1); 
        quickSort(arr, pi + 1, high); 
    } 
} 

// roll the N dices 
void roll_multiple_dice(int N, int *dice_rolls)
{
    for (int i = 0; i < N; i++) {
        dice_rolls[i] = (rand() % 6) + 1;
    }
}

// return the score for 1s-turn
int ones(int N, int *dice_rolls)
{
    int c = 0;
    for (int i = 0; i < N && c < 5; i++) {
        if(dice_rolls[i] == 1) c++;
    }
    return c;
}

// return the score for 2s-turn
int twos(int N, int *dice_rolls)
{
    int c = 0;
    for (int i = 0; i < N && c < 5; i++) {
        if(dice_rolls[i] == 2) c++;
    }
    return c * 2;
}

// return the score for 3s-turn
int threes(int N, int *dice_rolls)
{
    int c = 0;
    for (int i = 0; i < N && c < 5; i++) {
        if(dice_rolls[i] == 3) c++;
    }
    return c * 3;
}

// return the score for 4s-turn
int fours(int N, int *dice_rolls){
    int c = 0;
    for (int i = 0; i < N && c < 5; i++){
        if(dice_rolls[i] == 4) c++;
    }
    return c * 4;
}

// returns the score for 5s-turn
int fives(int N, int *dice_rolls)
{
    int c = 0;
    for (int i = 0; i < N && c < 5; i++) {
        if(dice_rolls[i] == 5) c++;
    }
    return c * 5;
}

// returns the score for 6s-turn
int sixes(int N, int *dice_rolls) 
{
    int c = 0;
    for (int i = 0; i < N && c < 5; i++) {
        if(dice_rolls[i] == 6) c++;
    }
    return c * 6;
}

// return the score for one-pair turn
int one_pair(int N, int *dice_rolls)
{
    int map[7] = {0, 0, 0, 0, 0, 0, 0};
    int r = 0;
    for (int i = 0; i < N; i++) {
        map[dice_rolls[i]]++;
    }
    for (int i = 1; i <= 6; i++) {
        if(map[i] > 1) r = i * 2;
    }
    return r; 
}

// return the score of two-pairs turn
int two_pairs(int N, int *dice_rolls)
{
    int map[7] = {0, 0, 0, 0, 0, 0, 0};
    int p1 = 0, p2 = 0;
    for (int i = 0; i < N; i++) {
        map[dice_rolls[i]]++;
    }
    for (int i = 1; i <= 6; i++) {
        if(map[i] > 1) {
            if(p1 == 0)
                p1 = i * 2;
            else
                p2 = p1; p1 = i * 2;
        }
    }
    if(p1 && p2)    
        return p1 + p2;
    
    return 0; 
}

// return the score of a three-of-a-kind turn
int three_of_a_kind(int N, int *dice_rolls)
{
    int map[7] = {0, 0, 0, 0, 0, 0, 0};
    int r = 0;
    for (int i = 0; i < N; i++) {
        map[dice_rolls[i]]++;
    }
    for (int i = 1; i <= 6; i++) {
        if(map[i] > 2) r = i * 3;
    }
    return r; 
}

// return the score of a four-of-a-kind turn
int four_of_a_kind(int N, int *dice_rolls)
{
    int map[7] = {0, 0, 0, 0, 0, 0, 0};
    int r = 0;
    for (int i = 0; i < N; i++) { 
        map[dice_rolls[i]]++;
    }
    for (int i = 1; i <= 6; i++) {
        if(map[i] > 3) r = i * 4;
    }
    return r; 
}

// returns the score for small-straight turn
int small_straight(int N, int *dice_rolls)
{
    int map[7] = {0, 0, 0, 0, 0, 0, 0};
    for (int i = 0; i < N; i++) {
        map[dice_rolls[i]]++;
    }
    int r = 0;
    for (int i = 1; i <= 5; i++) {
        if(map[i] != 0) r += i;
    }
    if(r == 15) 
        return r;
    
    return 0;
}

// return the score for large-straight turn
int large_straight(int N, int *dice_rolls)
{
    int map[7] = {0, 0, 0, 0, 0, 0, 0};
    for (int i = 0; i < N; i++) {
        map[dice_rolls[i]]++;
    }
    int r = 0;
    for (int i = 2; i <= 6; i++) {
        if(map[i] != 0) r += i;
    }

    if(r == 20) 
        return r;
    
    return 0;
}

// return the score for full-house turn
int full_house(int N, int *dice_rolls)
{

    int map[7] = {0, 0, 0, 0, 0, 0, 0};
    int map2[7] = {0, 0, 0, 0, 0, 0, 0};
    int t[7] = {0, 0, 0, 0, 0, 0, 0};
    int p[7] = {0, 0, 0, 0, 0, 0, 0};
    int tr = 0, pr = 0, tr2 = 0;

    for (int i = 0; i < N; i++) {
        map[dice_rolls[i]]++;
        if(map[dice_rolls[i]] >= 3) {
            t[dice_rolls[i]] = 1;
        }
    }

    for (int i = 0; i < N; i++) {
        map2[dice_rolls[i]]++;
        if(map2[dice_rolls[i]] >= 2 && !t[dice_rolls[i]]) 
            p[dice_rolls[i]] = 1;
    }

    for (int i = 1; i <= 6; i++) {        
        if(t[i]) {
            if(tr) 
                tr2 = tr;
            
            tr = i;
        }
        if(p[i]) 
            pr = i;
    }
    
    if((tr * 3) + (tr2 * 2) >= (tr * 3) + (pr * 2)) {
        if(tr && tr2) 
            return (tr * 3) + (tr2 * 2);
        else if(tr && pr) 
            return (tr * 3) + (pr * 2);
    }
    else {
        if(tr && pr) 
            return (tr * 3) + (pr * 2);
        else if(tr && tr2) 
            return (tr * 3) + (tr2 * 2);
        
    }
    return 0;
}

// returns the score of a chance-turn
int chance(int N, int *dice_rolls)
{
    int dice_rolls_sorted[N];
    for (int i = 0; i < N; i++) {
        dice_rolls_sorted[i] = dice_rolls[i];
    }
    quickSort(dice_rolls_sorted, 0, N - 1);
    int r = 0;
    for (int i = N - 1; i >= N - 5; i--) {
        r += dice_rolls_sorted[i];
    }
    return r;
    
}

// returns the score of a yatzy turn
int yatzy(int N, int *dice_rolls) 
{
    int found = 0;
    int map[7] = {0, 0, 0, 0, 0, 0, 0};
    for (int i = 0; i < N; i++){
        map[dice_rolls[i]]++;
    }
    for (int i = 1; i <= 6; i++){
        if(map[i] >= 5){
            found = 1;
            break;
        }
    }
    if(found) 
        return 50;
    
    return 0;
}