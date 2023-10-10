int main()
{
    int arr[10] = {6, -2000, -2, 42, 3, -221, 7, 12, 9, 33};

    for (int i = 0; i < 9; i++)
    {
        int minIndex = i;

        for (int j = i + 1; j < 10; j++)
            if (arr[j] < arr[minIndex])
                minIndex = j;
        if (minIndex != i)
        {
            int temp = arr[i];
            arr[i] = arr[minIndex];
            arr[minIndex] = temp;
        }
    }
}