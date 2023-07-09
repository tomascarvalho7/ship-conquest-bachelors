# Ship Conquest

<h1 align="center">
    <img src="https://github.com/tomascarvalho7/ship_conquest/blob/main/gallery/main.png">
</h1>

<p align="center">
  <i align="center">Multiplayer strategic sailing exploring game ⚓</i>
</p>

## Concept

<p align="center">
    <img width="30%" src="https://github.com/tomascarvalho7/ship_conquest/blob/main/gallery/explore.png" alt="explore"/>
&nbsp;
    <img width="30%" src="https://github.com/tomascarvalho7/ship_conquest/blob/main/gallery/conquest.png" alt="conquest"/>
&nbsp;
    <img width="30%" src="https://github.com/tomascarvalho7/ship_conquest/blob/main/gallery/fight.png" alt="fight"/>
</p>

The project consists of a multiplayer exploration RTS game (Real Time Strategy Game), that allows players to take control of a fleet of ships, explore a vast world, conquer islands, and engage in thrilling battles with other players.
    
This repository contains both the client application developed in Flutter & designed for mobile devices running on *Android*, and a back-end app hosted by the *Google Cloud Platform*.

Several technical concepts were worked on, namely *Procedural Generation* and pseudo-random noise algorithms such as *Perlin Noise* and *Simplex Noise* for the generation of the game's worlds, interpolation functions such as *Bézier Curves*, to represent the paths taken by the ships, and search algorithms such as *A Star Algorithm* to find paths between points.

## Galery

<p align="center">
    <img width="49%" src="https://github.com/tomascarvalho7/ship_conquest/blob/main/gallery/ship.png" alt="game"/>
&nbsp;
    <img width="49%" src="https://github.com/tomascarvalho7/ship_conquest/blob/main/gallery/minimap.png" alt="minimap"/>
</p>

## Features

- **Fleet Management**: Players can control and manage a fleet of ships. They can set sail on a controlled path to explore the worlds content.

- **Exploration**: The game provides a immersive but simple world for players to explore. They can navigate their ships across the seas and discover uncharted islands.

- **Island Conquest**: Players can engage in conquests to claim and control islands.

- **Player Battles**: Ship Conquest allows players to engage in exciting battles with each other.

## Architecture

In the following figure, a representative scheme of the system architecture is presented, also showing the technologies used in each module.
![System Architecture](https://github.com/tomascarvalho7/ship_conquest/blob/main/gallery/architecture.png)~

## Repository Structure

This repository is organized into two main directories: `flutter` and `jvm`.

### Flutter

The `flutter` directory contains the source code for the client application developed in Flutter. Here are some key files and directories within this directory:

- `lib/`: This directory contains the main Flutter code for the client application. It includes various components, screens, and utilities used in the game.

- `pubspec.yaml`: This file specifies the dependencies and assets used in the Flutter project.

- `README.md`: A README file specific to the client application, providing additional details and instructions for running the client.

### Jvm

The `jvm` directory contains the source code for the backend application developed with Spring. Here are some key files and directories within this directory:

- `src/`: This directory contains the main source code for the backend application. It includes controllers, services, and models used to handle API requests and manage game data.

- `pom.xml`: This file is the Maven project object model file for managing dependencies and project configurations.

- `README.md`: A README file specific to the backend application, providing additional details and instructions for running the server.

## Contact

If you have any questions, issues, or suggestions regarding Ship Conquest, please feel free to contact the developers, Tomas Carvalho and Francisco Barreiras, via the GitHub repository or through other contact information provided in the repository's profile.

## Version 2.0

With the **2.0 version** this project is currently on the **Released** Stage.
