#include <iostream>
#include <vector>
using namespace std ;

#define signOne 'X'
#define signTwo 'Z'

vector<vector<vector<char> > > boardMapping(vector<int> colRow) {
    vector<vector<vector<char> > > board(colRow[1]) ;

    for (int i = 0; i < colRow[1]; i++) {
        for (int j = 0; j < colRow[0]; j++) {
           vector<char> character(2) ;
           character[0] = '-' ;
           cin >> character[1] ;
           board[i].push_back(character) ;
        } 
    }

    return board ;
}

vector<vector<int> > hintsFiller(vector<int> colRow) {
    int repeat_for_signs = 2 ;
    int repeat_for_ColRow = 2 ;
    vector<vector<int> > hints ;

    for (int i = 0; i < repeat_for_ColRow ; i++)
        for (int j = 0; j < repeat_for_signs; j++) {
            vector<int> hintGroup ;
            for (int k = 0; k < colRow[i]; k++) {
                int hint ;
                cin >> hint ;
                hintGroup.push_back(hint) ;
            }
            hints.push_back(hintGroup);
        }
    
    return hints ;
}

vector<vector<int> > testHintsFiller(vector<int> colRow) {
    int repeat_for_ColRow = 2 ;
    vector<vector<int> > testHints ;

    for (int i = 0; i < repeat_for_ColRow ; i++) {
        vector<int> testHint(colRow[i],0) ;
        testHints.push_back(testHint) ;
        testHints.push_back(testHint) ;
    }

    return testHints ;
}

void printer(const vector<vector<vector<char> > >& board) {
    for (int i = 0; i < board.size(); i++) {
        int reminder ;

        for (int j = 0; j < board[1].size() - 1; j++) {
            cout << board[i][j][0] << " " ;
            reminder = j ;
        }

        cout << board[i][reminder+1][0] << endl ;
    }
}

bool safe(const vector<vector<vector<char> > >& board, int row, int column, char sign) {
    if (board[row][column][0] != '-')
        return false ;

    if (0 <= column-1)
        if (board[row][column-1][0] == sign)
            return false ;

    if (0 <= row-1)
        if (board[row-1][column][0] == sign)
            return false ;

    if (column+1 < board[1].size())
        if (board[row][column+1][0] == sign)
            return false ;

    if (row+1 < board.size())
        if (board[row+1][column][0] == sign)
            return false ;    
    
    return true ;
}

bool puttingSignTwo(vector<vector<vector<char> > >& board, int row, int column, int targetRow, int targetColumn, char sign, vector<int>& Z_block, vector<vector<int> >& testHints,const vector<vector<int> >& hints) {
    if (board[row][column][1] == sign) {
        if(!safe(board, targetRow, targetColumn, signTwo) || hints[1][targetColumn] == testHints[1][targetColumn] || hints[3][targetRow] == testHints[3][targetRow])
            return false;

        board[targetRow][targetColumn][0] = signTwo;
        testHints[1][targetColumn] += 1 ;
        testHints[3][targetRow] += 1 ;
        Z_block = {targetRow, targetColumn} ;
    }

    return true ;
}

bool checkerCol(vector<vector<int> >& testHints, vector<vector<vector<char> > >& board, const vector<vector<int> >& hints, int row) {
    if (testHints[2][row] == hints[2][row] || hints[2][row] == -1 ) {
        if (row == board.size()-1) {
            for (int i = 0; i < hints.size(); i++)
                for (int j = 0; j < hints[i].size() ; j++)
                    if (hints[i][j] != -1)
                        if (hints[i][j] != testHints[i][j])
                            return false ;

            return true ;
        }
        
        if(checkerCol(testHints, board, hints, row+1))
            return true ;
    }

    for (int i = 0; i < board[1].size() ; i++) {
        vector<int> Z_block(2) ;

        if(!safe(board, row, i, signOne) || hints[0][i] == testHints[0][i] || hints[2][row] == testHints[2][row])
            continue;

        if (!puttingSignTwo(board, row, i, row, i+1, 'L', Z_block, testHints, hints))
            continue;
        if (!puttingSignTwo(board, row, i, row, i-1, 'R', Z_block, testHints, hints))
            continue;
        if (!puttingSignTwo(board, row, i, row+1, i, 'T', Z_block, testHints, hints))
            continue;
        if (!puttingSignTwo(board, row, i, row-1, i, 'B', Z_block, testHints, hints))
            continue;

        board[row][i][0] = signOne ;
        testHints[0][i] += 1 ;
        testHints[2][row] += 1 ;
        
        if (checkerCol(testHints, board, hints, row))
            return true ;

        board[row][i][0] = '-';
        board[Z_block[0]][Z_block[1]][0] = '-' ;
        testHints[0][i] -= 1 ;
        testHints[2][row] -= 1 ;
        testHints[1][Z_block[1]] -= 1 ;
        testHints[3][Z_block[0]] -= 1 ;
    }

    return false ;
}

bool checkerRow(vector<vector<int> >& testHints, vector<vector<vector<char> > >& board,const vector<vector<int> >& hints, int column) {
    if (testHints[0][column] == hints[0][column] || hints[0][column] == -1) {
        if (column == board[1].size()-1) {
            if(checkerCol(testHints, board, hints, 0))
                return true ;
            return false ;
        }
        
        if(checkerRow(testHints, board, hints, column+1))
            return true ;
    }

    for (int i = 0; i < board.size() ; i++) {
        vector<int> Z_block(2) ;

        if(!safe(board, i, column,signOne) || hints[0][column] == testHints[0][column] || hints[2][i] == testHints[2][i])
            continue;

        if (!puttingSignTwo(board, i, column, i, column+1, 'L', Z_block, testHints, hints))
            continue;
        if(!puttingSignTwo(board, i, column, i, column-1, 'R', Z_block, testHints, hints))
            continue;
        if (!puttingSignTwo(board, i, column, i+1, column, 'T', Z_block, testHints, hints))
            continue;
        if (!puttingSignTwo(board, i, column, i-1, column, 'B', Z_block, testHints, hints))
            continue;

        board[i][column][0] = signOne;
        testHints[0][column] += 1 ;
        testHints[2][i] += 1 ;
        
        if (checkerRow(testHints, board, hints, column))
            return true ;

        board[i][column][0] = '-';
        board[Z_block[0]][Z_block[1]][0] = '-' ;
        testHints[0][column] -= 1 ;
        testHints[2][i] -= 1 ;
        testHints[1][Z_block[1]] -= 1 ;
        testHints[3][Z_block[0]] -= 1 ;
    }

    return false ;
}

int main() {
    vector<int> colRow(2) ;
    cin >> colRow[1] >> colRow[0] ;

    vector<vector<vector<char> > > board = boardMapping(colRow) ;
    vector<vector<int> > hints = hintsFiller(colRow) ;
    vector<vector<int> > testHints = testHintsFiller(colRow) ;
    
    if (checkerRow(testHints, board, hints, 0))
        printer(board);
    else
        cout << "No Solution!" << endl ;

    return 0 ;
}