import json
import requests
from typing import Tuple, Any
from colorama import Fore, Style, init




init(autoreset=True)


coin_list = ["xmr", "qrl"]



# Calculates cryptocurrency mining profits in coins and US dollars
def profit(hashrate: float, coin: str) -> Tuple[float, float]:
    difficulty, last_reward, price = get_coin_stats(coin)
    if difficulty > 0:
        reward = (hashrate * 3600) / difficulty * last_reward
        reward_usd = reward * price
        return reward, reward_usd
    else:
        return 0.0, 0.0


# Searches and displays the most profitable cryptocurrencies to mine based on hashrate
def find_best_coin(hashrate):
    rewards = {}

    for coin in coin_list:
        reward, reward_usd = profit(hashrate, coin)
        rewards[coin] = reward_usd

    best_coin = max(rewards, key=rewards.get)
    print(f"\n{Fore.GREEN}--- The most profitable coin: {best_coin.upper()} ---")
    print(f"It earns {Fore.YELLOW}{rewards[best_coin]:.4f}$ per hour!{Style.RESET_ALL} \n")


# Calculates and displays rewards for mining cryptocurrency at a given hashrate for various time periods
def calculate_and_display_rewards(hashrate, coin):
    reward, reward_usd = profit(hashrate, coin)
    timeframes = {
        "hour": 1,
        "day": 24,
        "week": 24 * 7,
        "month": 24 * 30,
        "year": 24 * 365
    }

    print(f"\n{Fore.CYAN}--- Rewards for {coin.upper()} ---")
    for timeframe, multiplier in timeframes.items():
        print(f"For {timeframe}: {reward * multiplier:.9f} {coin} | {Fore.YELLOW}{reward_usd * multiplier:.4f}$")
    print(f"{Style.RESET_ALL}")


# Gets cryptocurrency statistics (difficulty, block reward and price) from the API and returns them as a tuple or 0.0 in case of error
def get_coin_stats(coin: str) -> Tuple[float, float, float]:
    try:
        response = requests.get(f'https://api.minerstat.com/v2/coins?list={coin}')
        response.raise_for_status()
        data = response.json()
        coin_data = next(
            (item for item in data if item["coin"].upper() == coin.upper()),
            None
        )

        if coin_data is None:
            raise ValueError(f"Coin '{coin}' not found in the response.")

        return coin_data['difficulty'], coin_data['reward_block'], coin_data['price']

    except requests.exceptions.RequestException as e:
        print(f"{Fore.RED}Error fetching coin stats: {e}{Style.RESET_ALL}")
        return 0.0, 0.0, 0.0
    except ValueError as ve:
        print(f"{Fore.RED}{ve}{Style.RESET_ALL}")
        return 0.0, 0.0, 0.0



# Asks the user for the name of the cryptocurrency or a command to find the most profitable one, and then asks for the hashrate, 
# Checking the correctness of the input, and calling the appropriate functions to calculate rewards or find the best cryptocurrency.
while True:
    coin = input("Enter cryptocurrency (or 'best' to find the most profitable): \n--> ").strip().lower()

    if coin in coin_list or coin == "best":
        while True:
            try:
                hashrate_input = input("Enter hashrate in H/s: \n--> ")
                hashrate = float(hashrate_input)

                if hashrate < 0:
                    print(f"\n{Fore.RED}Hashrate must be a non-negative number.{Style.RESET_ALL}\n")
                    continue
                
                break
            except ValueError:
                print(f"\n{Fore.RED}Invalid input. Please enter a non-negative number.{Style.RESET_ALL}\n")

        if coin in coin_list:
            calculate_and_display_rewards(hashrate, coin)
        elif coin == "best":
            find_best_coin(hashrate)
    else:
        print(f"\n{Fore.RED}Invalid input. Please enter one of the following cryptocurrencies: xmr, qrl, or 'best'.{Style.RESET_ALL}\n")
