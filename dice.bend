# Define the LCGState object with fields for modulus, multiplier (a), increment (c), and seed
object LCGState { modulus, a, c, seed }

# Linear Congruential Generator (LCG) function to generate a new random number and state
def lcg(state):
  open LCGState: state  # Unpack fields from the state object
  new_seed = (state.a * state.seed + state.c) % state.modulus  # Compute new seed
  return (new_seed / state.modulus, LCGState { modulus: state.modulus, a: state.a, c: state.c, seed: new_seed })  # Return normalized random number and updated state

# Function to simulate rolling two dice using the LCG
def roll_dice(state):
  (val1, state1) = lcg(state)  # Generate first random value
  (val2, state2) = lcg(state1)  # Generate second random value
  roll1 = (val1 * 6 + 1)  # Convert first value to dice roll (1-6)
  roll2 = (val2 * 6 + 1)  # Convert second value to dice roll (1-6)
  return (roll1 + roll2, state2)  # Return the sum of two dice rolls and updated state

# Function to update the results list with the new dice roll
def update_results(results, roll):
  match results:
    case List/Cons:
      if roll == 0:
        return List/Cons { head: results.head + 1, tail: results.tail }  # Increment the count at the head
      else:
        return List/Cons { head: results.head, tail: update_results(results.tail, roll - 1) }  # Recursively update the appropriate position
    case List/Nil:
      return results  # Return the results list when it's empty

# Function to simulate n dice rolls and update the results list
def simulate(generator, results, count):
  if count == 0:
    return results  # Return results when count reaches 0
  else:
    (roll, gen) = roll_dice(generator)  # Roll the dice and get new generator state
    return simulate(gen, update_results(results, roll), count - 1)  # Recursively simulate remaining rolls

# Function to run the Monte Carlo simulation for n rolls
def monte_carlo_simulation(n):
  initial_results = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]  # Initialize results list with zeros
  final_results = simulate(LCGState { modulus: 1677726, a: 48271, c: 0, seed: 1 }, initial_results, n)  # Run simulation
  return calculate_probabilities(final_results, n)  # Calculate probabilities

# Function to calculate probabilities from the results list
def calculate_probabilities(results, n):
  match results:
    case List/Cons:
      return List/Cons { head: results.head / n, tail: calculate_probabilities(results.tail, n) }  # Normalize counts to probabilities
    case List/Nil:
      return List/Nil  # Return empty list when results list is empty

# Custom 'and' function to handle logical conjunction
def and(a, b):
  match a:
    case Bool/True:
      return b
    case Bool/False:
      return Bool/False

# Function to format probabilities for output
def format_probabilities(probabilities, idx):
  fold probabilities with idx:
    case List/Cons:
      if and(idx > 1, idx < 13):
        return List/Cons { head: "Roll " + idx + ": " + (probabilities.head * 100) + "%", tail: format_probabilities(probabilities.tail, idx + 1) }  # Format probability string
      else:
        return format_probabilities(probabilities.tail, idx + 1)  # Skip indices outside range 2-12
    case List/Nil:
      return List/Nil  # Return empty list when probabilities list is empty

# Main function to run the Monte Carlo simulation and return formatted probabilities
def main:
  probabilities = monte_carlo_simulation(100)  # Run simulation with 100 rolls
  return format_probabilities(probabilities, 0)  # Return formatted probabilities
