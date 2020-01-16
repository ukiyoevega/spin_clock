## Spin Clock

Spin Clock is an entry for [Flutter Clock Challenge](flutter.dev/clock). 

## Feature

- Readability

  - Spin clock use three different clock faces to represent hour, minute and second respectively. 

  - The top right corner second face is sized to a small scale in contrast to the other two to avoid disturbance. 

  - For hour and minute, relatively large font size is used to make sure the time is easy to read even from a distance.

- Fluency

  - Animation between different seconds at top right in a way indicate time flows slowly. The position of the second number moves along circular orbit smoothly, while the size of it grows.
  - The number become still when the second arrives. And start animating again showing next second starts. The whole process take place and last forever.
  - To remain consistency, hour and minute animation works like the second's, excpet that the interval is set to hour and minute.

- Beauty

  - Intuitive colorful weather icons.
  - Realistic looking clock faces.
  - Visually effective dark mode and light mode. 

- Accessbility

  Spin clock support screen reading of time and weather, in addition to that, sufficient color contrast is used between digits and background, makes the  current time even more easy to read. 