def with_captured_stdout
  original_stdout = $stdout  # capture previous value of $stdout
  $stdout = StringIO.new     # assign a string buffer to $stdout
  yield                      # perform the body of the user code
  $stdout.string             # return the contents of the string buffer
ensure
  $stdout = original_stdout  # restore $stdout to its previous value
end

def polygon( center_x, center_y, segments, radius, invert=false)
  points = []
  dRad = 2*Math::PI/segments

  (0..segments).each { |i|
    rads = dRad * i
    y = Math.sin(rads) * radius
    x = Math.cos(rads) * radius
    if invert
      x = -x
    end
    points.push([center_x + (x.abs < 0.01 ? 0.0 : x), center_y + (y.abs < 0.01 ? 0.0 : y)])
  }
  points
end

def make_robot

puts "<svg viewBox='0 0 1024 1024' xmlns='http://www.w3.org/2000/svg'>"

stroke_color = "white"
stroke_width_px = 10 + rand(20)
stroke_width = "#{stroke_width_px}px"

face_color = "black"
face_rx = 10 + rand(150)

image_x = 1024
image_y = 1024
head_width = 300 + rand(500)
head_height = 300 + rand(200)
head_left = (image_x - head_width)/2
head_top  = (image_y - head_height) / 2
head_center = head_left + head_width/2

colors = %w[black white green blue yellow red purple orange brown gray]

eye_offset = head_height / 4 + rand( head_height/4 )
eye_color = colors.sample
eye_width = head_width/2.5 + rand(head_width/5)
eyes_y = head_top + eye_offset
eyes_d = head_width/20 + rand(head_width/4)
eyes_d2 = head_width/20 + rand(head_width/4)
eye_left_x = head_center - eye_width/2
eye_right_x = eye_left_x + eye_width
eye_stroke_color = rand(2) == 1 ? eye_color : stroke_color

ear_d = 30 + rand(60)
ear_d2 = 30 + rand(60)
ear_color = eye_color #colors.sample
ear_y = eyes_y + ear_d

nose_x = head_center
nose_d = 20 + rand(80)
nose_d2 = 20 + rand(80)
nose_y = head_top + head_height/2

mouth_offset = head_height/4 + rand(head_height/8)
mouth_y = nose_y + mouth_offset

mouth_offset_x = rand(eye_width/2)
mouth_left = eye_left_x + mouth_offset_x
mouth_right = eye_right_x - mouth_offset_x


#ears
puts "<ellipse cx='#{head_left}' cy='#{ear_y}' rx='#{ear_d}' ry='#{ear_d2}' stroke='#{stroke_color}' stroke-width='#{stroke_width}' fill='#{ear_color}' />"
puts "<ellipse cx='#{head_left + head_width}' cy='#{ear_y}' rx='#{ear_d}' ry='#{ear_d2}' stroke='#{stroke_color}' stroke-width='#{stroke_width}' fill='#{ear_color}' />"

#antenna
puts "<ellipse cx='#{head_center}' cy='#{head_top}' rx='#{ear_d2}' ry='#{ear_d}' stroke='#{stroke_color}' stroke-width='#{stroke_width}' fill='#{ear_color}' />"

#face
puts "<rect x='#{head_left}' y='#{head_top}' stroke='#{stroke_color}' stroke-width='#{stroke_width}' fill='#{face_color}' width='#{head_width}' height='#{head_height}' rx='#{face_rx}'/>"

#mouth
puts "<circle cx='#{mouth_left}' cy='#{mouth_y - ear_d}' r='#{ear_d}' stroke='#{stroke_color}' stroke-width='#{stroke_width}' fill='none' />"
puts "<rect x='#{mouth_left+1}' y='#{mouth_y - ear_d- 1}' fill='#{face_color}' width='#{ear_d*2}' height='#{ear_d}' />"
puts "<rect x='#{mouth_left- ear_d - stroke_width_px}' y='#{mouth_y - ear_d*2 - stroke_width_px}' fill='#{face_color}' width='#{ear_d*3}' height='#{ear_d + stroke_width_px}' />"
puts "<circle cx='#{mouth_right}' cy='#{mouth_y - ear_d}' r='#{ear_d}' stroke='#{stroke_color}' stroke-width='#{stroke_width}' fill='none' />"
puts "<rect x='#{mouth_right - 1 - ear_d - stroke_width_px}' y='#{mouth_y - ear_d- 1}' fill='#{face_color}' width='#{ear_d}' height='#{ear_d}' />"
puts "<rect x='#{mouth_right- ear_d - stroke_width_px}' y='#{mouth_y - ear_d*2 - stroke_width_px}' fill='#{face_color}' width='#{ear_d*2}' height='#{ear_d + stroke_width_px}' />"
puts "<line x1='#{mouth_left}' y1='#{mouth_y}' x2='#{mouth_right}' y2='#{mouth_y}' stroke='#{stroke_color}' stroke-width='#{stroke_width}' />"

#face outline again in case mouth crushed it
puts "<rect x='#{head_left}' y='#{head_top}' stroke='#{stroke_color}' stroke-width='#{stroke_width}' fill='none' width='#{head_width}' height='#{head_height}' rx='#{face_rx}'/>"

#eyes
shape = rand(4)
if shape > 2
  puts "<ellipse cx='#{eye_left_x}' cy='#{eyes_y}' rx='#{eyes_d}' ry='#{eyes_d2}' stroke='#{eye_stroke_color}' stroke-width='#{stroke_width}' fill='#{eye_color}' />"
  puts "<ellipse cx='#{eye_right_x}' cy='#{eyes_y}' rx='#{eyes_d}' ry='#{eyes_d2}' stroke='#{eye_stroke_color}' stroke-width='#{stroke_width}' fill='#{eye_color}' />"
else
  segments = 3 + rand(10)
  left_eye = polygon( eye_left_x, eyes_y, segments, eyes_d)
  right_eye = polygon( eye_right_x, eyes_y, segments, eyes_d, true)

  pairs = left_eye.map { |a| [a.join(",")] }

  puts "<polygon points='#{pairs.join(" ")}' stroke='#{eye_stroke_color}' stroke-width='#{stroke_width}' fill='#{eye_color}' />"
  pairs = right_eye.map { |a| [ a.join(",")] }
  puts "<polygon points='#{pairs.join(" ")}' stroke='#{eye_stroke_color}' stroke-width='#{stroke_width}' fill='#{eye_color}' />"
end
#nose
shape = rand(4)
if shape > 2
  puts "<ellipse cx='#{nose_x}' cy='#{nose_y}' rx='#{nose_d}' ry='#{nose_d2}' stroke='#{stroke_color}' stroke-width='#{stroke_width}' fill='#{ear_color}' />"
else
  segments = 3 + rand(10)
  nose = polygon( nose_x, nose_y, segments, nose_d)
  pairs = nose.map { |a| [ a.join(",")] }
  puts "<polygon points='#{pairs.join(" ")}' stroke='#{stroke_color}' stroke-width='#{stroke_width}' fill='#{ear_color}' />"
end

puts "</svg>"
end

File.open("robot_index.html","w+"){ |index|
  (1..3000).each do |num|
    index.write("<img height='64px' width='64px' src='#{num}.svg'>")
    File.open("#{num}.svg","w"){ |robot|
      robot.write with_captured_stdout{ make_robot }
    }
  end
}
