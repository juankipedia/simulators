import collections

size = 3
  
def get_zero_coordinates(state):
    for i in range(0, size):
        for j in range(0, size):
            if state[size * i + j] == '0':
                return i, j

def print_state(state):
    for i in range(0, size):
        print(' '.join(state[size * i : size * i + 3]))
    print("")

def get_new_state(current_state, elem_i, elem_j, zero_i, zero_j):
    elem_pos = size * elem_i + elem_j
    zero_pos = size * zero_i + zero_j
    if zero_pos < elem_pos:
        return current_state[0: zero_pos] + current_state[elem_pos] + current_state[zero_pos + 1: elem_pos] + \
        current_state[zero_pos] + current_state[elem_pos + 1: size * size]
    else :
        return current_state[0: elem_pos] + current_state[zero_pos] + current_state[elem_pos + 1: zero_pos] + \
        current_state[elem_pos] + current_state[zero_pos + 1: size * size]
            
def solve_(state):
    i, j = get_zero_coordinates(state)

    q = collections.deque()
    
    q.append((state, i, j))
    visited = {state}
    goal_state = "012345678"
    indexes = [[-1, 0], [0,1], [1,0], [0, -1]]
    n_states = 0

    while len(q) != 0 :
        c_n = q.popleft() 
        c_s, i, j = c_n
        print_state(c_s)
        n_states += 1
        if c_s == goal_state:
            break
        for index in indexes:
            n_i = i + index[0]
            n_j = j + index[1]
            if n_i >= 0 and n_i <= (size - 1) and n_j >= 0 and n_j <= (size - 1): 
                n_s =  get_new_state(c_s, n_i, n_j, i, j)
                if n_s not in visited:
                    visited.add(n_s)
                    q.append((n_s, n_i, n_j))
    print(n_states)

def solve(state):
    solve_(''.join([str(elem) for row in state for elem in row]))

solve([[1, 0, 2], [3, 4, 5], [6, 7, 8]])