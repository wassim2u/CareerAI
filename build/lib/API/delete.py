
def max_profit(prices: list[int]) -> int:
    """
    Finds the maximum profit that can be made by buying and selling the stock once.

    Args:
        prices: A list of integers representing the daily stock prices.

    Returns:
        The maximum profit that can be made.
    """
    # Your code here
    l , r = 0, 1
    buy, sell = prices[l], prices[r]
    maxim = sell - buy
    for i in range(0,len(prices)):
        for j in range(i+1,len(prices)):
            if prices[j] - prices[r] > maxim:
                maxim = prices[j] - prices[r]

    return maxim
