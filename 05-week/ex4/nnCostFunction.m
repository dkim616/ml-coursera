function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% fprintf('SIZE OF THETA 1 grad: %f\n', size(Theta1_grad));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% fprintf('y %f\n', y);

new_y = zeros(m, num_labels);
for i = 1:m
  % fprintf('y %f\n', y(i));
  new_y(i, y(i)) = 1;
end
% fprintf('new_y %f\n', new_y);

in1 = [ones(m,1), X];
a1 = X;
z2 = in1 * Theta1';
a2 = sigmoid(z2);
% fprintf('size %f\n', size(a2));

in2 = [ones(m,1), a2];
z3 = in2 * Theta2';
a3 = sigmoid(z3);
% fprintf('size2 %f\n', size(a3));

% fprintf('%f\n', Theta1);
reduced_theta1 = Theta1(:, 2:input_layer_size+1);
theta1_sum = sum(sum(reduced_theta1 .* reduced_theta1));

reduced_theta2 = Theta2(:, 2:hidden_layer_size+1);
theta2_sum = sum(sum(reduced_theta2 .* reduced_theta2));

J = sum(sum((-new_y .* log(a3) .- (1 .- new_y) .* log(1 .- a3)) / m, 2)) + lambda / (2 * m) * (theta1_sum + theta2_sum);
% J = (-y' * log(a3) .- (1 .- y)' * log(1 .- a3)) / m + lambda / (2 * m) * combTheta' * combTheta;


% delta3 = a3 .- new_y;
% fprintf('SIZE OF Delta 3: %f\n', size(delta3));

% delta2 = (delta3 * Theta2)(:, 2:end) .* sigmoidGradient(z2);
% delta2 = delta2(2:end);

for t = 1:m

  a1 = X(t,:);
  in1 = [1, X(t,:)];
  z2 = in1 * Theta1';
  a2 = sigmoid(z2);
  in2 = [1, sigmoid(z2)];
  z3 = in2 * Theta2';
  a3 = sigmoid(z3);

  delta3 = a3 .- new_y(t,:);
  delta2 = (delta3 * Theta2)(2:end) .* sigmoidGradient(z2);
  % delta2 = delta2(:, 2:end);
  % fprintf('SIZE OF Delta 2: %f\n', size(delta2));
  % fprintf('SIZE OF a1: %f\n', size(a1));
  % fprintf('SIZE OF Delta 3: %f\n', size(delta3));
  % fprintf('SIZE OF a2: %f\n', size(a2));

  Theta1_grad = Theta1_grad .+ delta2' * in1;
  Theta2_grad = Theta2_grad .+ delta3' * in2;

end

Theta1_grad(:, 2:end) = Theta1_grad(:, 2:end) .+ Theta1(:, 2:end) * lambda; 
Theta2_grad(:, 2:end) = Theta2_grad(:, 2:end) .+ Theta2(:, 2:end) * lambda; 

Theta1_grad = Theta1_grad / m;
Theta2_grad = Theta2_grad / m;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];

end
