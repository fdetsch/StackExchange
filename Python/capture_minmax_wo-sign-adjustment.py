# Question 'NEAT-Python fails to capture extreme values' ----
# (available online: https://stackoverflow.com/questions/55243619/neat-python-fails-to-capture-extreme-values)

import os
os.chdir('Python')


### ENVIRONMENT ====

### . packages ----

import os
import neat

import numpy as np
import matplotlib.pyplot as plt
import random


### . sample data ----

x = np.sin(np.arange(.01, 4000 * .01, .01)) * 10


### NEAT ALGORITHM ====

# . fitness function ----

def eval_genomes(genomes, config):
  for genome_id, genome in genomes:
    genome.fitness = 4.0
    net = neat.nn.FeedForwardNetwork.create(genome, config)
    for xi in zip(abs(x)):
      output = net.activate(xi)
      genome.fitness -= (output[0] - xi[0]) ** 2


# . neat run ----

## checkpoints target folder
odr = 'neat-checkpoints'
if not os.path.exists(odr):
  os.mkdir(odr)

def run(config_file, n = None):
  # load configuration
  config = neat.Config(neat.DefaultGenome, neat.DefaultReproduction,
                       neat.DefaultSpeciesSet, neat.DefaultStagnation,
                       config_file)
  # create the population, which is the top-level object for a NEAT run
  p = neat.Population(config)
  # add a stdout reporter to show progress in the terminal
  p.add_reporter(neat.StdOutReporter(True))
  stats = neat.StatisticsReporter()
  p.add_reporter(stats)
  p.add_reporter(neat.Checkpointer(5, filename_prefix = "neat-checkpoints/neat-checkpoint-))
  # run for up to n generations
  winner = p.run(eval_genomes, n)
  return(winner)


### . model evolution ----

random.seed(1899)
winner = run('config-feedforward', n = 50)


### . prediction ----

## extract winning model
config = neat.Config(neat.DefaultGenome, neat.DefaultReproduction,
                     neat.DefaultSpeciesSet, neat.DefaultStagnation,
                     'config-feedforward')

winner_net = neat.nn.FeedForwardNetwork.create(winner, config)

## make predictions
y = []
for xi in zip(x):
  y.append(winner_net.activate(xi))

## display sample vs. predicted data
plt.plot(range(len(x)), x, color='darkgrey', label = 'observed', linewidth = 6)
plt.plot(range(len(x)), y, color='black', label = 'predicted', linewidth = 1.5)
plt.hlines(0, xmin = 0, xmax = len(x), colors = 'grey', linestyles = 'dashed')
plt.xlabel("Index")
plt.ylabel("Offset")
plt.legend(bbox_to_anchor = (0., 1.02, 1., .102), loc = 10,
           ncol = 2, mode = None, borderaxespad = 0.)
plt.show()
plt.clf()

