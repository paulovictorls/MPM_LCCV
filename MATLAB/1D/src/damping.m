function [ fdamp ] = damping( alpha, node )

fdamp = - alpha * abs(node.iforce + node.eforce) * sign(node.velocity);

end

