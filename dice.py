def lcg(modulus, a, c, seed):
    """Linear congruential generator."""
    while True:
        seed = (a * seed + c) % modulus
        yield seed / modulus  # Generate a floating-point number between 0 and 1

# Create a generator
generator = lcg(modulus=2**32, a=1103515245, c=12345, seed=1)

def roll_dice():
    return int(generator.__next__() * 6 + 1) + int(generator.__next__() * 6 + 1)

def monte_carlo_simulation(n):
    results = [0]*13
    for _ in range(n):
        roll = roll_dice()
        results[roll] += 1
    probabilities = [x / n for x in results]
    return probabilities

# Run the simulation with 1,000,000 rolls
probabilities = monte_carlo_simulation(1000000)

for i in range(2, 13):
    print(f"Roll {i}: {probabilities[i]*100:.2f}%")