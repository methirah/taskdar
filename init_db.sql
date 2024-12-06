DROP TABLE IF EXISTS Goals_Tasks;
DROP TABLE IF EXISTS Tasks_Tags;
DROP TABLE IF EXISTS Repeated;
DROP TABLE IF EXISTS Goals;
DROP TABLE IF EXISTS Tasks;
DROP TABLE IF EXISTS Tags;
DROP TABLE IF EXISTS Priority;

CREATE TABLE IF NOT EXISTS Priority (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE -- eisenhower matrix
);

CREATE TABLE IF NOT EXISTS Tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT,
    due_date DATE,
    priority_id INTEGER NOT NULL,
    FOREIGN KEY (priority_id) REFERENCES Priority(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Tags (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE -- eg: "Work", "Personal", "Fitness"
);

CREATE TABLE IF NOT EXISTS Tasks_Tags (
    task_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    PRIMARY KEY (task_id, tag_id),
    FOREIGN KEY (task_id) REFERENCES Tasks(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES Tags(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Repeated (
    reference_id INTEGER NOT NULL, -- either a task id or goal id
    reference_type TEXT NOT NULL, -- task or goal
    start_date DATE NOT NULL,
    end_date DATE,
    rule TEXT NOT NULL, -- eg: "Biweekly, Daily, Monthly",
    UNIQUE (reference_id, reference_type),
    PRIMARY KEY (reference_id, reference_type),
    CHECK (reference_type IN ('Task', 'Goal'))
);

CREATE TABLE IF NOT EXISTS Goals (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL, -- eg: "Weekly Gym", "Daily", "Job Hunt"
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    repeat_rule TEXT, -- eg: "weekly", "monthly"
    completion_measure TEXT
);

CREATE TABLE IF NOT EXISTS Goals_Tasks (
    goal_id INTEGER NOT NULL,
    task_id INTEGER NOT NULL,
    frequency INTEGER DEFAULT 1,
    PRIMARY KEY (goal_id, task_id),
    FOREIGN KEY (goal_id) REFERENCES Goal(id) ON DELETE CASCADE,
    FOREIGN KEY (task_id) REFERENCES Tasks(id) ON DELETE CASCADE
);

INSERT INTO Priority (name) VALUES
('Important & Urgent'),
('Important & Non-Urgent'),
('Unimportant & Urgent'),
('Unimportant & Non-Urgent');

INSERT INTO Tags (name) VALUES
('Work'),
('Fitness'),
('Personal'),
('Study');

INSERT INTO Tasks (title, description, due_date, priority_id) VALUES
('Complete Project', 'Finish the final project for the course', '2024-12-06', 1),
('Leg Day', 'Warmup with spanish squats and do knee rehab', '2024-12-20', 2),
('Finish COMP2404 Tutorial 24', 'its drop one anyways', '2024-12-8', 3),
('Finish LRT Trillium Line', 'Make sure it breaks down :)', '2025-01-10', 4);

INSERT INTO Goals (name, description, start_date, end_date, completion_measure, repeat_rule) VALUES
('Weekly Gym Goal', 'Go to the gym 3 times this week', '2024-12-01', '2024-12-07', '3 sessions per week', 'Weekly'),
('Study Goal', 'Complete all study sessions for the week', '2024-12-01', '2024-12-07', '5 hours of study per week', 'Weekly');

INSERT INTO Tasks_Tags (task_id, tag_id) VALUES
(1, 1),  -- Task "Complete Project" -> Label "Work"
(2, 2),  -- Task "Go to Gym" -> Label "Fitness"
(3, 3);  -- Task "Read Book" -> Label "Personal"

INSERT INTO Goals_Tasks (goal_id, task_id) VALUES
(1, 2),  -- Goal "Weekly Gym Goal" -> Task "Go to Gym"
(2, 3);  -- Goal "Study Goal" -> Task "Read Book"

-- Repeating Task: Go to Gym (every week on Thursday)
INSERT INTO Repeated (reference_id, reference_type, start_date, end_date, rule) VALUES
(2, 'Task', '2024-12-05', '2024-12-26', 'Weekly');

-- Repeating Goal: Weekly Study Goal
INSERT INTO Repeated (reference_id, reference_type, start_date, end_date, rule) VALUES
(1, 'Goal', '2024-12-05', '2024-12-12', 'Daily');

