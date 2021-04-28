%
% $Id: cover.mp,v 1.2 2003/11/17 18:53:43 edt1023 Exp $
%
beginfig(1)
  for i=1 step -.01 until 0:
    fill fullcircle scaled (i*5cm) withcolor i*.8[red,white];
  endfor
  for j=0 upto 12:
    draw (0,0){dir 30}..{dir 8j}(8cm,0) withcolor .6[blue,white];
  endfor
endfig;
end
