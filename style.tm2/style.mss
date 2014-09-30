#osmdiff {
    [zoom <= 11] {
      line-color: #ffff00;
      line-join: round;
      line-cap: round;
      line-width: .5;
  
      [zoom <= 8] { line-width: .4; }
      [zoom <= 7] { line-width: .25; }
      [zoom <= 6] { line-width: .1; }
      [zoom <= 4] { line-width: .05; }
    }
}

#tiger20062014 {
  [age="new"] {
    line-color: #ffff00;
    line-join: round;
    line-cap: round;

    [zoom>=12] { line-width: 1; }
    [zoom>=13] { line-width: 1; }
    [zoom>=14] { line-width: 1; }
    [zoom>=15] { line-width: 2; }

    [zoom >= 16] {
      line-width: 2;
      text-name: '[fullname]';
      text-face-name: 'Source Sans Pro Bold';
      text-placement:line;
      text-avoid-edges: true;
      text-wrap-width: 100;
      text-wrap-before: true;
      text-fill: #fff;
      text-halo-radius: 2;
      text-halo-fill: #000;
      text-size: 11;
      text-wrap-width: 50;
      text-dy: 12;

      [zoom >= 17] { text-size: 16; text-dy: 16 }
      [zoom >= 18] { text-size: 22; text-dy: 22 }
    }
  }
  

  [age="both"] {
    line-color: #dddd00;

    [zoom >= 16] {
      line-join: round;
      line-cap: round;

      line-width: 2;
      text-name: '[fullname]';
      text-face-name: 'Source Sans Pro Bold';
      text-placement:line;
      text-avoid-edges: true;
      text-wrap-width: 100;
      text-wrap-before: true;
      text-fill: #fff;
      text-halo-radius: 2;
      text-halo-fill: #000;
      text-size: 11;
      text-dy: 12;

      [zoom >= 17] { text-size: 16; text-dy: 16 }
      [zoom >= 18] { text-size: 22; text-dy: 22 }
    }
  }

  // Footway, steps, track, bike, bridle
  [class="S1710"],[class="S1720"],[class="S1500"],[class="S1820"],[class="S1830"],
  // Service, alley, private, parking, internal(=driveway?)
  [class="S1640"],[class="S1730"],[class="S1740"],[class="S1780"],[class="S1750"] {
     [zoom < 14] {
       line-width:0
     }
     [zoom>=15] {
       line-width: 1;
     }
  }

  //Rail
  [class="R1011"],[class="R1051"],[class="R1052"] {
     line-color: #8888FF; 
  }
}

#rail [zoom <= 15],
#road [zoom <= 15],
#tunnel [zoom <= 15],
#bridge [zoom <= 15] {
  ['mapnik::geometry_type'=2] {
    line-color: #000;
    line-width: 0.5;
    line-join: round;
    line-cap: round;
    [class='major_rail'],
    [class='minor_rail'],
    [class='street'],
    [class='motorway'],
    [class='motorway_link'],
    [class='main_link'],
    [class='main'],
    [class='service'],
    [class='driveway'],
    [class='path'],
    [class='street_limited'] {
      [zoom>=12] { line-width: 2; }
      [zoom>=13] { line-width: 2; }
      [zoom>=14] { line-width: 3; }
      [zoom>=15] { line-width: 6; }
    }
    [class='street_limited'] { line-dasharray: 4,1; }
  }
  comp-op: dst-out;
}

