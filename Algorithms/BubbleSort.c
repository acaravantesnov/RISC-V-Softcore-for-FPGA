int main()
{
    int arr[10] = {6, -2000, -2, 42, 3, -221, 7, 12, 9, 33};

    for (int i = 0; i < 9; i++)
    {
        for(int j = 0; j < 9 - i; j++)
        {
            if (arr[j + 1] < arr[j])
            {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}