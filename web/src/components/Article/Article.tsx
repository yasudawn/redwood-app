import { Link, routes } from '@redwoodjs/router'

const Article = ({ post }) => {
  return (
    <article>
      <header>
        <h2>
          <Link to={routes.article({ id: post.id })}>{post.title}</Link>
        </h2>
      </header>
      <div>{post.body}</div>
      <div>Posted at: {post.createdAt}</div>
    </article>
  )
}

export default Article
