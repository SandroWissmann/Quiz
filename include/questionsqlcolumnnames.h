/* Quiz
 * Copyright (C) 2020  Sandro Wißmann
 *
 * Quiz is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Quiz is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Quiz If not, see <http://www.gnu.org/licenses/>.
 *
 * Web-Site: https://github.com/SandroWissmann/Quiz
 */
#ifndef SQLQUESTIONSCOLUMNNAMES_H
#define SQLQUESTIONSCOLUMNNAMES_H

namespace QuestionColumn {
static constexpr auto id = 0;
static constexpr auto askedQuestion = 1;
static constexpr auto answer1 = 2;
static constexpr auto answer2 = 3;
static constexpr auto answer3 = 4;
static constexpr auto answer4 = 5;
static constexpr auto correct_answer = 6;
static constexpr auto picture = 7;
} // namespace QuestionColumn

#endif // SQLQUESTIONSCOLUMNNAMES_H
