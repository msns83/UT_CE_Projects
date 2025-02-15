def merge_sort(sorted_left,sorted_right):
    leftP = 0
    rightP = 0
    temp = []

    while (rightP < len(sorted_right) and leftP < len(sorted_left)):
        if (sorted_right[rightP] < sorted_left[leftP]):
            temp.append(sorted_right[rightP])
            rightP += 1
        else:
            temp.append(sorted_left[leftP])
            leftP += 1
    
    while (leftP < len(sorted_left)):
        temp.append(sorted_left[leftP])
        leftP +=1
    
    while (rightP < len(sorted_right)):
        temp.append(sorted_right[rightP])
        rightP += 1

    return temp


def count_middle_ranges(left_part,right_part,Lower,Upper):
    left_pointer = 0
    righ_pointer_lower = 0
    righ_pointer_upper = 0
    ans = 0

    while (left_pointer < len(left_part)):
        while (righ_pointer_upper < len(right_part) and right_part[righ_pointer_upper]-left_part[left_pointer] <= Upper):
            righ_pointer_upper += 1
        while (righ_pointer_lower < len(right_part) and right_part[righ_pointer_lower]-left_part[left_pointer] < Lower):
            righ_pointer_lower += 1
        
        ans += righ_pointer_upper - righ_pointer_lower
        left_pointer += 1
    
    return ans


def count_ranges(Arr, Lower, Upper):
    if (len(Arr) == 1 and Lower <= Arr[0] <= Upper):
        return Arr , 1
    elif(len(Arr) <= 1):
        return Arr , 0
    
    
    mid = len(Arr) // 2
    ans = 0

    sorted_left , ans1 = count_ranges(Arr[0:mid], Lower, Upper)
    sorted_right , ans2 = count_ranges(Arr[mid:len(Arr)], Lower, Upper)
    ans += ans1 + ans2

    ans += count_middle_ranges(sorted_left,sorted_right,Lower,Upper)
    return merge_sort(sorted_left,sorted_right) , ans



def main():
    Arr = list(map(int,input().split()))
    Lower, Upper = map(int , input().split()) 
    sum_upto = [Arr[0]]
    for i in range(1,len(Arr)):
        sum_upto.append(sum_upto[i-1]+Arr[i])
    

    _ , ans = count_ranges(sum_upto, Lower, Upper)
    print(ans)

main()