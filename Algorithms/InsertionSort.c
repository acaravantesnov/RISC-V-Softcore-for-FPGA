int main()
{
    int arr[10] = {6, -2000, -2, 42, 3, -221, 7, 12, 9, 33};

    int i, key, j;

    for (int i = 1; i < 10; i++)
    {
        key = arr[i];
        j = i - 1;
        while (j > -1 && arr[j] > key)
        {
            arr[j + 1] = arr[j];
            j = j - 1;
        }
        arr[j + 1] = key;
    }
}