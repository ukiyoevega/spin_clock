## Spin Clock

Spin Clock is an entry for [Flutter Clock Challenge](flutter.dev/clock). 

## Feature

- Readability

  - Spin clock uses three different dial plates to represent hour, minute and second respectively.
  - For hour and minute dial, large font is used to ensure that time can be recognized even from a distance.
  - Second dial at the upper right corner is designed to be much smaller than the other two dials to avoid disturbance. 

- Fluency

  - Animation was designed to emphasize the time is ticking. 
  - The numbers on the second dial move smoothly along the circular orbit. The next second number is enlarged while moving, staying in the middle of the orbit shortly to indicate arrival, and then moves to shrink. The whole process take place and last forever. 
  - The hour and minute dials are animated similar to the second's, except that the interval is set to hours and minutes.


- Beauty

  - Intuitive colorful weather icons
  - Realistic looking clock faces
  - Visually impressive dark mode and light mode

- Accessbility

  Spin clock support screen reading of time and weather. In addition to that, the high color contrast between numbers and background makes the current time easier to read. 
