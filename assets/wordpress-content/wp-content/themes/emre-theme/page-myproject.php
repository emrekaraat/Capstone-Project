<?php
/*
Template Name: My Project Page
*/
get_header(); ?>

<main id="main" class="site-main">
    <section>
        <?php the_content(); ?>

        <h2>Galatasaray Logo</h2>
        <img src="<?php echo get_template_directory_uri(); ?>/themes/twentytwentyfive/images/gs-logo.jpg" alt="GS Logo" width="300">

        <h2>UEFA Cup Victory</h2>
        <img src="<?php echo get_template_directory_uri(); ?>/themes/twentytwentyfive/images/gs-uefa-cup.jpg" alt="UEFA Cup" width="300">

        <h2>Me at the Stadium</h2>
        <img src="<?php echo get_template_directory_uri(); ?>/themes/twentytwentyfive/images/gs-emre-1.jpg" alt="Emre at Stadium" width="300">
    </section>
</main>

<?php get_footer(); ?>
