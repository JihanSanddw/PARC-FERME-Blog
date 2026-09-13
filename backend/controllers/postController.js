const { error } = require('node:console');
const db = require('../config/database');

const getAllPosts = async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT
                p.id_post,
                p.title,
                p.slug,
                p.excerpt,
                p.content,
                p.image,
                p.is_featured,
                p.created_at,
                p.updated_at,

                c.id_category,
                c.name AS category,

                a.id_author,
                a.name AS author,

                d.id_driver,
                d.name AS driver,

                t.id_team,
                t.name AS team,

                r.id_race,
                r.grand_prix AS race,
                r.circuit,
                r.race_date

            FROM posts p

            JOIN categories c
                ON p.id_category = c.id_category

            JOIN authors a
                ON p.id_author = a.id_author

            LEFT JOIN drivers d
                ON p.id_driver = d.id_driver

            LEFT JOIN teams t
                ON p.id_team = t.id_team

            LEFT JOIN races r
                ON p.id_race = r.id_race

            ORDER BY p.created_at DESC
            `);

            res.status(200).json({
                success: true,
                data: rows
            });
    } catch (error) {
        console.error(error);

        res.status(500).json({
            success: false,
            message: 'Failed to fetch posts',
        });
    }
};

const getPostById = async (req, res) => {
    try {
        const id = req.params.id;

        const [rows] = await db.query(`
                        SELECT
                p.id_post,
                p.title,
                p.slug,
                p.excerpt,
                p.content,
                p.image,
                p.is_featured,
                p.created_at,
                p.updated_at,

                c.id_category,
                c.name AS category,

                a.id_author,
                a.name AS author,

                d.id_driver,
                d.name AS driver,

                t.id_team,
                t.name AS team,

                r.id_race,
                r.grand_prix AS race,
                r.circuit,
                r.race_date

            FROM posts p

            JOIN categories c
                ON p.id_category = c.id_category

            JOIN authors a
                ON p.id_author = a.id_author

            LEFT JOIN drivers d
                ON p.id_driver = d.id_driver

            LEFT JOIN teams t
                ON p.id_team = t.id_team

            LEFT JOIN races r
                ON p.id_race = r.id_race

            WHERE p.id_post = ?
            `, [id]);

            if (rows.length === 0) {
                return res.status(404).json({
                    success: false,
                    message: 'Post not found'
                })
            }

            res.status(200).json({
                success: true,
                data: rows[0]
            })

    } catch (error) {
        console.error(error);

        res.status(500).json({
            success: false,
            message: 'Failed to retrieve post',
        });
        
    }
}

const createPost = async (req, res) => {
    const connection = await db.getConnection();

    try {
        const {
            title,
            excerpt,
            content,
            image,
            id_category,
            author_name,
            id_driver,
            id_team,
            id_race,
            is_featured
        } = req.body;

        console.log('CREATE POST BODY:', req.body);

        if (
            !title ||
            !content ||
            !id_category ||
            !author_name
        ) {
            return res.status(400).json({
                success: false,
                message: 'Title, content, category, and author are required'
            });
        }

        await connection.beginTransaction();

        const [authors] = await connection.query(
            'SELECT id_author FROM authors WHERE name = ?',
            [author_name.trim()]
        );

        let idAuthor;

        if (authors.length > 0) {
            idAuthor = authors[0].id_author;
        } else {
            const [authorResult] = await connection.query(
                'INSERT INTO authors (name) VALUES (?)',
                [author_name.trim()]
            );

            idAuthor = authorResult.insertId;
        }

        const [result] = await connection.query(
            `
            INSERT INTO posts
            (
                title,
                excerpt,
                content,
                image,
                id_category,
                id_author,
                id_driver,
                id_team,
                id_race,
                is_featured
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            `,
            [
                title.trim(),
                excerpt?.trim() || null,
                content.trim(),
                image || null,
                id_category,
                idAuthor,
                id_driver || null,
                id_team || null,
                id_race || null,
                is_featured || false
            ]
        );

        await connection.commit();

        res.status(201).json({
            success: true,
            message: 'Post created successfully',
            data: {
                id_post: result.insertId
            }
        });

    } catch (error) {
        await connection.rollback();

        console.error('CREATE POST ERROR:', error);

        res.status(500).json({
            success: false,
            message: 'Failed to create post',
            error: error.message
        });
    } finally {
        connection.release();
    }
};

const updatePost = async (req, res) => {
    const connection = await db.getConnection();

    try {
        const { id } = req.params;

        const {
            title,
            slug,
            excerpt,
            content,
            image,
            id_category,
            author_name,
            id_driver,
            id_team,
            id_race,
            is_featured
        } = req.body;

        console.log('UPDATE POST BODY:', req.body);

        if (
            !title ||
            !content ||
            !id_category ||
            !author_name
        ) {
            return res.status(400).json({
                success: false,
                message: 'Title, content, category, and author are required'
            });
        }

        const [existingPost] = await connection.query(
            'SELECT id_post FROM posts WHERE id_post = ?',
            [id]
        );

        if (existingPost.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Post not found'
            });
        }

        await connection.beginTransaction();

        const [authors] = await connection.query(
            'SELECT id_author FROM authors WHERE name = ?',
            [author_name.trim()]
        );

        let idAuthor;

        if (authors.length > 0) {
            idAuthor = authors[0].id_author;
        } else {
            const [authorResult] = await connection.query(
                'INSERT INTO authors (name) VALUES (?)',
                [author_name.trim()]
            );

            idAuthor = authorResult.insertId;
        }

        await connection.query(
            `
            UPDATE posts
            SET
                title = ?,
                slug = ?,
                excerpt = ?,
                content = ?,
                image = ?,
                id_category = ?,
                id_author = ?,
                id_driver = ?,
                id_team = ?,
                id_race = ?,
                is_featured = ?
            WHERE id_post = ?
            `,
            [
                title.trim(),
                slug?.trim() || null,
                excerpt?.trim() || null,
                content.trim(),
                image || null,
                id_category,
                idAuthor,
                id_driver || null,
                id_team || null,
                id_race || null,
                is_featured || false,
                id
            ]
        );

        await connection.commit();

        res.status(200).json({
            success: true,
            message: 'Post updated successfully'
        });

    } catch (error) {
        await connection.rollback();

        console.error('UPDATE POST ERROR:', error);

        res.status(500).json({
            success: false,
            message: 'Failed to update post',
            error: error.message
        });

    } finally {
        connection.release();
    }
};

const deletePost = async (req, res) => {
    try {
        const { id } = req.params;

        const [existingPost] = await db.query(
            'SELECT id_post FROM posts WHERE id_post = ?', [id]
        );

        if (existingPost.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Post not found'
            });
        }

        await db.query(
            'DELETE FROM posts WHERE id_post = ?', [id]
        );

        res.status(200).json({
            success: true,
            message: 'Post deleted successfully'
        });
    } catch (erro) {
        console.error(error);

        res.status(500).json({
            success: false,
            message: 'Failed to delete post'
        });
    }
}

module.exports = {
    getAllPosts,
    getPostById,
    createPost,
    updatePost,
    deletePost
};