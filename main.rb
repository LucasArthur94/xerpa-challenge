POSITIONS = ['N', 'E', 'S', 'W']
MOVEMENTS = ['L', 'R', 'M']

def go_forward(probe)
  raise "Invalid position" if !POSITIONS.include? probe[2]
  
  return [probe[0], (probe[1].to_i + 1).to_s, probe[2]] if probe[2] == 'N'
  return [(probe[0].to_i + 1).to_s, probe[1], probe[2]] if probe[2] == 'E'
  return [probe[0], (probe[1].to_i - 1).to_s, probe[2]] if probe[2] == 'S'
  return [(probe[0].to_i - 1).to_s, probe[1], probe[2]] if probe[2] == 'W'
end

def rotate(probe, movement)
  return [probe[0], probe[1], POSITIONS[(POSITIONS.index(probe[2]) + 1) % 4]] if movement == 'R'
  return [probe[0], probe[1], POSITIONS[(POSITIONS.index(probe[2]) - 1) % 4]] if movement == 'L'
end

def move_probe(probe, edge, all_probes, index)
  probe_init, movements = probe

  other_probes = all_probes.reject.with_index do | other_probe, other_index |
    index == other_index
  end

  probes_coordinates = other_probes.map { | probe | [probe[0], probe[1]] }

  movements.map do | movement |
    raise "Invalid movement" if !MOVEMENTS.include? movement
    if (movement == 'M')
      probe_init = go_forward(probe_init)
    else
      probe_init = rotate(probe_init, movement)
    end

    raise "Collision" if probes_coordinates.include? [probe_init[0], probe_init[1]]
    raise "Out of range" if ((probe_init[0].to_i < 0 || probe_init[0].to_i > edge[0].to_i) || (probe_init[1].to_i < 0 || probe_init[1].to_i > edge[1].to_i))
  end

  all_probes[index] = probe_init

  probe_init
end

def get_file_input
  if ARGV.length != 1
    raise "Please input probes file name"
  end

  File.open(ARGV[0]).readlines.each { |line| line.chomp! }
end

def main
  edge_string, *probe_instructions_string = get_file_input

  edge = edge_string.split
  probe_instructions = probe_instructions_string.each_slice(2).to_a

  probes = probe_instructions.map do | probe_instruction |
    [
      probe_instruction[0].split,
      probe_instruction[1].split('')
    ]
  end

  all_probes = probes.map { |probe| probe[0] }

  final_positions = probes.map.with_index do |probe, index|
    move_probe(probe, edge, all_probes, index)
  end

  print final_positions
end

main