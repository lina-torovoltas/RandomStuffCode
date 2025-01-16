#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <math.h>
#include <string.h>


#define MAX_EXPR_LEN 256



// Function for checking an expression for correctness
int is_valid_expression(const char *expr) {
    int balance = 0;
    for (size_t i = 0; expr[i] != '\0'; i++) {
        char c = expr[i];

        // Allowed characters: numbers, operators, parentheses, spaces and points
        if (isdigit(c) || c == '+' || c == '-' || c == '*' || c == '/' || c == '^' || c == '(' || c == ')' || c == ' ' || c == '.') {
            // Checking the correctness of parentheses
            if (c == '(') {
                balance++;
            } else if (c == ')') {
                balance--;
                if (balance < 0) {
                    return 0;
                }
            }
        } else {
            return 0;
        }
    }
    return balance == 0;
}



// Function prototypes for evaluating expressions
float evaluate_expression(const char **expr);
float evaluate_term(const char **expr);
float evaluate_factor(const char **expr);



// Function to calculate the degree
float power(float base, float exp) {
    return pow(base, exp);
}


// Skip spaces in expression
void skip_spaces(const char **expr) {
    while (**expr == ' ') {
        (*expr)++;
    }
}


// Main function to evaluate the expression
float evaluate_expression(const char **expr) {
    float result = evaluate_term(expr);
    while (**expr == '+' || **expr == '-') {
        char op = **expr;
        (*expr)++;
        skip_spaces(expr);
        if (op == '+') {
            result += evaluate_term(expr);
        } else {
            result -= evaluate_term(expr);
        }
    }
    return result;
}


// Function for calculating multiplication and division
float evaluate_term(const char **expr) {
    float result = evaluate_factor(expr);
    while (**expr == '*' || **expr == '/') {
        char op = **expr;
        (*expr)++;
        skip_spaces(expr);
        if (op == '*') {
            result *= evaluate_factor(expr);
        } else {
            result /= evaluate_factor(expr);
        }
    }
    return result;
}


// Function for calculating factors (parentheses, numbers and powers)
float evaluate_factor(const char **expr) {
    skip_spaces(expr);
    float result;
    
    // If there is an opening parenthesis, then we recursively evaluate the expression inside
    if (**expr == '(') {
        (*expr)++;
        result = evaluate_expression(expr);
        skip_spaces(expr);
        if (**expr == ')') {
            (*expr)++;
        } else {
            printf("Error: unmatched brackets!\n");
            exit(EXIT_FAILURE); // Bracket mismatch error
        }
    } else if (isdigit(**expr) || **expr == '.') {
        char *end;
        result = strtof(*expr, &end);
        *expr = end;
    } else {
        printf("Error: invalid expression!\n");
        exit(EXIT_FAILURE); // Invalid expression
    }
    
    skip_spaces(expr);
    if (**expr == '^') {
        (*expr)++;
        result = power(result, evaluate_factor(expr));
    }
    return result;
}


// Main function of the program
int main() {
    char expression[MAX_EXPR_LEN];

    printf("Enter an expression: ");
    if (!fgets(expression, MAX_EXPR_LEN, stdin)) {
        printf("Input error!\n");
        return 1;
    }

    // Remove the newline character at the end of the line
    size_t len = strlen(expression);
    if (expression[len - 1] == '\n') {
        expression[len - 1] = '\0';
    }

    // Check the correctness of the expression
    if (!is_valid_expression(expression)) {
        printf("Error: the expression contains invalid characters or is improperly formed!\n");
        return 1;
    }

    // Calculate the result
    const char *expr_ptr = expression;
    float result = evaluate_expression(&expr_ptr);
    skip_spaces(&expr_ptr);

    // If there are extra characters at the end of the expression, write an error
    if (*expr_ptr != '\0') {
        printf("Error: invalid expression!\n");
        return 1;
    }

    // Print the result with four decimal places
    printf("Result: %.4f\n", result);
    return 0;
}
