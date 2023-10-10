NAME			=	ensamblador_riscv

SRCS			=	main.cpp \
					./srcs/generate_mc.cpp \
					./srcs/open_files.cpp \
					./srcs/signed_to_binary.cpp

OBJS			=	$(SRCS:.cpp=.o)

CXX				=	clang++
RM				=	rm -f
CXXFLAGS		=	-Wall -Wextra -Werror -g -std=c++11 -pedantic

all:			$(NAME)

$(NAME):		$(OBJS)
				$(CXX) $(CXXFLAGS) -g -o $(NAME) $(OBJS)

clean:
				$(RM) $(OBJS)

fclean:			clean
				$(RM) $(NAME)

re:				fclean $(NAME)

test:			$(NAME)

.PHONY:			all clean fclean re test

